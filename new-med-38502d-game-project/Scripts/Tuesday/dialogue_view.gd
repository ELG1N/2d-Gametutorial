@abstract class_name DialogueView extends Control
## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Description:
## 	Provide a structure for children classes to easily extend for managing
## 	different types of dialogue.
##

#region loading resources
##
## Script full of enum types for communicating between the main scene, child 
## classes of this class and this class itself.
##
const GAME_TYPES: Resource \
= preload("res://Scripts/Tuesday/game_types.gd")

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
const DEFAULT_TEXT: String = "default text"

##
## The default size for the texture of dialogue boxes
##
const DEFAULT_SIZE: GAME_TYPES.DialogueBoxSizes \
= GAME_TYPES.DialogueBoxSizes.MEDIUM
#endregion

#region global variables
##
## Global variable for the box text, with getter and setter, because box text is
## variant. It is variant because it will be use full to allow for children of
## it to either handle single line dialogue where only one thing is said, and
## multi-text, where a sequence of dialogue is said, so the text type needs to
## either be a string, or an array of strings, hence why we need a setter to
## protect what value type the variable can be.
##
@export var box_text: Variant = DEFAULT_TEXT:
	get:
		return box_text
	set(_box_text):
		if _box_text is String or _box_text is Array[String]:
			box_text = _box_text
		else:
			box_text = DEFAULT_TEXT

##
## Global variable for the box size, not the same problem as the box text,
## its just if the size is updated, the texture of the box should be updated at
## the same time.
##
@export var box_size: GAME_TYPES.DialogueBoxSizes = DEFAULT_SIZE:
	get:
		return box_size
	set(_box_size):
		if _box_size != box_size:
			box_size = _box_size
			update_box_size(_box_size)
#endregion

#region inheritable class functions
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
func update_box_size(_box_size: GAME_TYPES.DialogueBoxSizes) -> void:
	match _box_size:
		GAME_TYPES.DialogueBoxSizeTypes.LARGE:
			update_children(Vector2(128.0, 32.0), LARGE_DIALOGUE_BOX)
		GAME_TYPES.DialogueBoxSizeTypes.MEDIUM:
			update_children(Vector2(64.0, 32.0), MEDIUM_DIALOGUE_BOX)
		GAME_TYPES.DialogueBoxSizeTypes.SMALL:
			update_children(Vector2(32.0, 32.0), SMALL_DIALOGUE_BOX)

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
func update_children(texture_size: Vector2, texture: Texture2D) -> void:
	%Texture.region_rect = texture_size
	%Texture.texture = texture
	%Text.size = Vector2(%DialogueDecoration.x - 8, %DialogueDecoration.y - 8)
#endregion

#region abstract class functions
##
## Name:
## 	update_box
##
## Description:
## 	updates information about the box when provided information about the box,
## 	pretty much a copy of the constructure, just don't want to reinitialize
## 	objects because that can become costly.
##
## Parameters:
## 	_box_size: [GAME_TYPES.DialogueBoxSizeTypes] -> The size of texture to use
## 													when rendering the box.
## 	_box_text: [Variant] -> the text that will be rendered in the box
## 			   [String]
## 			   [Array[String]]
##
## Returns:
## 	void
##
## Errors:
## 	None
##
@abstract func update_box(_box_size: GAME_TYPES.DialogueBoxSizes, _box_text: Variant) -> void;

##
## Name:
## 	_update_display_text
##
## Description:
## 	Really simple wrapper to update the text displayed by the dialogue box.
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
@abstract func update_display_text() -> void;
#endregion
