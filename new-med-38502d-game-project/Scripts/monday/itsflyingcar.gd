extends StaticBody2D
signal die


func _ready() -> void:
	pass # Replace with function body.
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	die.emit()
