extends CanvasLayer
var creditsbool: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Play.pressed.connect(play)
	$Exit.pressed.connect(exit)	
	$Credits.pressed.connect(credits)
	
func _process(delta: float) -> void:
	if creditsbool:
		%Credits2.show()
	elif creditsbool == false:
		%Credits2.hide()
func play():
	get_tree().change_scene_to_file("res://Scenes/Games/Monday.tscn")

func exit():
	get_tree().quit()
func credits():
	creditsbool = !creditsbool
	
