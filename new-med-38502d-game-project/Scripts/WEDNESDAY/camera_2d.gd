extends Camera2D

func _process(delta: float) -> void:
	self.position.y = %CharacterBody2D.position.y
