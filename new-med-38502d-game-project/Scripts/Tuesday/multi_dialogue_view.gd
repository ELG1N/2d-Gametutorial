class_name MultiDialogueView extends Control
## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Description:
## 	Manage data and events related to single dialogue events such as showing the
## 	dialogue box, hiding it when either the timer runs out or the player skips
## 	it. Also must be able to update the size of its background depending on what
## 	amount of text it is given.
##

##
## For the game scene to use when events must happen after the character speaks
##
signal dialogue_end


#region loading resources
##
## Dialogue box for large amounds of dialogue
##
const LARGE_DIALOGUE_BOX: Texture2D \
= preload("res://Assets/Sprites/Tuesday/large_dialogue_box.png")


##
## Dialogue box for medium amounts of dialogue
##
const MEDIUM_DIALOGUE_BOX: Texture2D \
= preload("res://Assets/Sprites/Tuesday/medium_dialogue_box.png")

##
## Dialogue Box for small amounts of dialogue
##
const SMALL_DIALOGUE_BOX: Texture2D \
= preload("res://Assets/Sprites/Tuesday/small_dialogue_box.png")
#endregion

#region default values
##
## The default value for the text that is viewed in the dialogue box
##
const DEFAULT_TEXT: Array = ["default text", "lorem ipsum", "beans"]

##
## Default value for the wait time
##
const WAIT_TIME: float = 5
#endregion

#region global variables
##
## Global variable for the box text
##
@export var box_text: Array = DEFAULT_TEXT

##
## Variable to change the texture used for the background of the dialogue box
## when the game is running.
##
@onready var dialogue_rect: TextureRect = %DialogueBox

##
## Variable to change the size of the dialogue text box, when the game is
## running.
##
@onready var dialogue_text: RichTextLabel = %DialogueText

##
## Variable to update current index of dialogue
##
var current_index = 0
#endregion

#region Node Functions
##
## Name:
## 	_ready
##
## Description:
## 	Called when node enter's scene tree, only have to hide it. Its text and
## 	texture can be set later.
##
## Parameters:
## 	None
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func _ready() -> void:
	hide()
#endregion

#region Dialogue Box Display
##
## Name:
## 	update_box_size
##
## Description:
## 	uses pattern matching to determine in what way to update the size of the box
## 	and the size of the text box within it.
##
## 	_box_size: [GAME_TYPES.DialogueBoxSizeTypes] -> The size of texture to use
## 													when rendering the box.
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func update_box() -> void:
	%DialogueText.text = box_text[current_index]
	var character_count = (box_text[current_index] as String).length()
	if character_count <= 20:
			update_children(Vector2(32.0, 32.0), SMALL_DIALOGUE_BOX)
	elif character_count <= 100:
			update_children(Vector2(64.0, 32.0), MEDIUM_DIALOGUE_BOX)
	else:
			update_children(Vector2(128.0, 32.0), LARGE_DIALOGUE_BOX)

##
## Name:
## 	update_children
##
## Description:
## 	updates some information about the children of the control node.
##
## Parameters:
## 	texture_size: [Vector2] -> the new size of the rect wrapping the texture
## 							   of the dialogue box.
## 	texture: [Texture2D] -> The new texture to use for the box.
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func update_children(texture_size: Vector2, new_texture: Texture2D) -> void:
	dialogue_rect.size = texture_size
	dialogue_rect.texture = new_texture
	dialogue_text.size.x = texture_size.x - 8

##
## Name:
## 	_show_and_start_timer
##
## Description:
## 	Show the dialogue, and start the timer so that it is not on the player's
## 	screen for too long.
##
## Parameters:
## 	None
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func show_and_start_timer(_box_text: Array):
	current_index = 0
	box_text = _box_text
	update_box()
	show()
	%DialogueViewTimer.start()

#endregion

#region Ending Dialogue & Sending Signals
##
## Name:
## 	skip_dialogue
##
## Description:
## 	Hide and restart wait timer for the single dialogue view, also emit the
## 	signal defined above.
##
## Parameters:
## 	None
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func skip_dialogue() -> void:
	current_index += 1
	if current_index >= box_text.size():
		%DialogueViewTimer.stop()
		dialogue_end.emit()
		hide()
	else:
		update_box()

##
## Name:
## 	_on_dialogue_view_timer_timeout
##
## Description:
## 	Hide and restart wait timer for the single dialogue view. Because it calls
## 	skip_dialogue (reusing function) the dialogue end signal will be emitted
## 	aswell.
##
## Parameters:
## 	None
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func _on_dialogue_view_timer_timeout() -> void:
	current_index += 1
	if current_index >= box_text.size():
		%DialogueViewTimer.stop()
		dialogue_end.emit()
		hide()
	else:
		update_box()
#endregion
