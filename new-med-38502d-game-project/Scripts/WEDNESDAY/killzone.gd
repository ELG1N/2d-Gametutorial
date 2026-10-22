extends Area2D


signal on_water
signal off_water


func _on_body_entered(body: Node2D) -> void:
	on_water.emit()


func _on_body_exited(body: Node2D) -> void:
	off_water.emit()
