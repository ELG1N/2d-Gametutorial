extends CharacterBody2D


const SPEED = 65
const JUMP_VELOCITY = -400.0
var hopping: bool = false
var on_log_left: bool = false
var on_log_right: bool = false

@export var tile_size := 16
@export var hop_time := 0.15
@export var hop_height := 6.0

@onready var sprite: AnimatedSprite2D = $Sprite3
@onready var shadow: Sprite2D = $Shadow
@onready var ray_cast: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	# Handle jump.
	if on_log_left:
		position.x += 0.47825
	if Input.is_action_just_pressed("Jump"):
		hop()
	if Input.is_action_pressed("LEFT"):
		$Sprite3.play("left walk")
		velocity.x =  (-SPEED)
	elif Input.is_action_pressed("RIGHT"):
		$Sprite3.play("right walk")
		velocity.x =  SPEED
	else:
		velocity.x = 0
		$Sprite3.play("baseidle")
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





func _on_static_body_2d_2_on_log_left() -> void:
	on_log_left = true


func _on_static_body_2d_2_not_on_log_left() -> void:
	on_log_left = false
