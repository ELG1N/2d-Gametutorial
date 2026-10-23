extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Button.pressed.connect(pause)
	$Button2.pressed.connect(menu)	
func input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		pause()
	
func menu():
	pause()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
