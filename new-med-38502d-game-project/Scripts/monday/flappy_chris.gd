extends CharacterBody2D
const MAX_DOWN = 90
const MAX_UP = -90
const SPEED = 75.0
const JUMP_VELOCITY = -130.0
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += (get_gravity()/1.75) * delta
		velocity.x = SPEED 
		rotation_degrees = clamp(velocity.y * 0.255, MAX_UP, MAX_DOWN)
		if is_dead == false:
			if Input.is_action_just_pressed("Jump"):
				velocity.y = JUMP_VELOCITY
				$AudioStreamPlayer2D.play()
				%AnimatedSprite2D.play("Fly")
	move_and_slide()

	
func Die():
	is_dead = true
	self.velocity.x = 0
	%AnimatedSprite2D.play("die")
	%AnimatedSprite2D.stop()
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://Scenes/Components/Monday/flappylose.tscn")


func _on_kill_body_entered(body: Node2D) -> void:
	Die()


#func _on_area_2d_area_entered(area: Area2D) -> void:
#	if self.position.x < 1061:
#		Die()
#	elif self.position.x > 1062:
#		get_tree().change_scene_to_file("res://Scenes/Components/Monday/flappywin.tscn")


func _on_win_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/Components/Monday/flappywin.tscn")


func _on_grandpa_die() -> void:
	Die()


func _on_rug_guys_die() -> void:
	Die()


func _on_its_light_guys_die() -> void:
	Die()
