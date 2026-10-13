extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureProgressBar.value = 100

func _reset() -> void:
	$TextureProgressBar.value = 100
	
func _update(new_charge: float) -> void:
	$TextureProgressBar.value = new_charge
