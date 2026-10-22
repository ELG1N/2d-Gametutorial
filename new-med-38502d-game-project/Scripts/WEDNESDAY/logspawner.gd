extends Node2D
@export var log: PackedScene
var spawn_interval: = randf_range(2, 3.5)
@export var log_speed: = 0
@export var left: bool = false



func _ready():
		$Timer.wait_time = spawn_interval

func spawn_log() -> void:
	var log_new = log.instantiate()
	log_new.global_position = $Marker2D.global_position
	if left:
		log_new.Logspeed = -log_speed
	elif not left:
		log_new.Logspeed = log_speed
	get_parent().add_child(log_new)

func _on_timer_timeout() -> void:
	spawn_log()
