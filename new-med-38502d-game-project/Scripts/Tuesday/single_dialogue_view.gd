class_name SingleDialogueView extends DialogueView
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

##
## Default value for the wait time
##
const WAIT_TIME: float = 10

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
func show_and_start_timer():
	show()
	%DialogueViewTimer.start()


##
## Name:
## 	update_box
##
## Description:
## 	updates information about the box when provided information about the box,
## 	pretty much a copy of the constructure, just don't want to reinitialize
## 	objects because from my experience in other languages that can become costly.
##
## Parameters:
## 	_box_size: [GAME_TYPES.DialogueBoxSizeTypes] -> The size of texture to use
## 													when rendering the box.
## 	_box_text: [String]
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func update_box(_box_size: GAME_TYPES.DialogueBoxSizes, _box_text: Variant) -> void:
	box_size = _box_size
	if _box_text is String:
		box_text = _box_text
		update_display_text()

##
## Name:
## 	update_display_text
##
## Description:
## 	Really simple wrapper to update the text displayed by the dialogue box.
##
## Parameters:
## 	_text: [String] -> The text to be displayed.
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func update_display_text() -> void:
	%Text.text = box_text
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
	hide()
	%DialogueViewTimer.stop()
	%DialogueViewTimer.wait_time = WAIT_TIME
	dialogue_end.emit()

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
	skip_dialogue()
#endregion
