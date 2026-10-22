extends CharacterBody2D


const SPEED = 65
const JUMP_VELOCITY = -400.0
var hopping: bool = false
var on_log_left: bool = false
var on_log_right: bool = false
var on_water: bool = false
var log_count: int = 0
var log_speed: float = 0
var death: int = 0
@export var tile_size := 16
@export var hop_time := 0.15
@export var hop_height := 6.0

@onready var sprite: AnimatedSprite2D = $Sprite3
@onready var shadow: Sprite2D = $Shadow
@onready var ray_cast: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	# Handle jump.
	checkdeath()
	if log_count > 0:
		position.x += log_speed * delta
	if Input.is_action_just_pressed("Jump"):
		hop()
		$AudioStreamPlayer2D.play()
	if Input.is_action_pressed("LEFT"):
		$Sprite3.play("left walk")
		velocity.x =  (-SPEED)
	elif Input.is_action_pressed("RIGHT"):
		$Sprite3.play("right walk")
		velocity.x =  SPEED
	else:
		velocity.x = 0
		$Sprite3.play("baseidle")
		checkdeath()
		if self.position.x < -89:
			self.position.x = -89
		elif self.position.x > 167:
			self.position.x = 167
	move_and_slide()


func hop():
	hopping = true
	if ray_cast.is_colliding():
		var t := create_tween()
		t.tween_property(self, "position", position + Vector2.UP * 0, hop_time)
		t.parallel().tween_method(_set_hop_progress, 0.0, 1.0, hop_time)
		await t.finished
		hopping = false
	else:
		var t := create_tween()
		t.tween_property(self, "position", position + Vector2.UP * tile_size, hop_time)
		t.parallel().tween_method(_set_hop_progress, 0.0, 1.0, hop_time)
		await t.finished
		hopping = false

func _set_hop_progress(p: float):
	var arc := sin(p * PI)        
	sprite.position.y = -arc * hop_height
	$Sprite3.play("baseidle")
	shadow.scale = Vector2.ONE * (1.0 - 0.3 * arc)


func set_log_speed(Logspeed):
	log_speed = Logspeed


func Die():
	if death == 1:
		set_process(false)
		set_physics_process(false)
		$Shadow.hide()
		$Sprite3.play("WaterDie")
		await get_tree().create_timer(5).timeout
		get_tree().quit()
	elif death == 2:
		set_process(false)
		set_physics_process(false)
		$Shadow.hide()
		#$Sprite3.play("WaterDie")
		await get_tree().create_timer(5).timeout
		get_tree().quit()

func enter_log():
	log_count += 1


func exit_log():
	log_count -= 1



func _on_killzone_on_water() -> void:
	on_water = true


func _on_killzone_off_water() -> void:
	on_water = false

func checkdeath():
	if on_water and log_count < 1 and !hopping:
		death = 1
		Die()
