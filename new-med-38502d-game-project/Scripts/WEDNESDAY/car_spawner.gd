extends Node2D
@export var car: PackedScene
var spawn_interval: = randf_range(1.55, 3.5)


func _ready():
		$Timer.wait_time = spawn_interval

func spawn_car() -> void:
	var car_new = car.instantiate()
	car_new.global_position = $Marker2D.global_position
	get_parent().add_child(car_new)

func _on_timer_timeout() -> void:
	spawn_car()
