extends Area2D
signal Die

func _process(delta: float) -> void:
	self.position.x += 45 * delta





func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.death = 2
		body.Die()
