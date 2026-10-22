extends Area2D


var Logspeed: int = 0




func _physics_process(delta: float) -> void:
	position.x += Logspeed * delta



func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			body.enter_log()
			body.set_log_speed(Logspeed)


func _on_body_exited(body: Node2D) -> void:
		if body.is_in_group("player"):
			body.exit_log()
