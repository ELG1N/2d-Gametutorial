# @Author: James Huston
# @Email:  huston@uleth.ca
#
# @Purpose:
# 	Describe all states & types that both the game scene & player scene will use.
#


#
# Inheritance & External Scripts
#
extends Node2D
const GameTypes: Resource = preload("res://Scripts/Wednesday/game_types.gd")


# Notes for Makysm or Chris, whomever reads this file:
# 1. a dialoge system would be super cool, but I have a lack of time,
# and making cool sprites took up alot of it.
#
# 2. Godot might have it's own state management system, I prefer
# having the complexity of software shown directly to my face.




# In place of a health bar, I think a battery is a really good
# tool to use, if the player is still in the sewer, then they're
# goose is cooked lol.
#
enum BatteryState {
	# player is good
	FULL,
	# should give player some form of warning
	HALF,
	# should give player another warning
	QUARTER,
	# should give player an urgent warning (maybe change text to red).
	TENTH,
	# if player is still in the maze, this will kill them.
	EMPTY,
}

# Track which map the player is in, if they enter the first map,
# and if they leave the sewer, will help with rendering different stagest
# of the game.
#
enum MapState {
	# Tell Player the controls
	INTRO,
	# blue maze
	ENTRY,
	# dark grey maze
	DEPTHS,
	# lighter maze
	EXIT,
	# image of fancy concrete sculpture
	SCHOOL,
}

# Actions either relating to this particular game that the player
# doesn't really need to handle, or in the case of SETTINGS, the
# game as a whole.
#f
enum ActionType {
	# Default/No-Recognized Buttons Pressed.
	MOVEMENT,
	# KEY_E Pressed
	INTERACT,
	# KEY_ESCAPE Pressed
	SETTINGS,
	# KEY_SPACE Pressed
	SKIP_DIALOGUE,
}

enum NPC {
	# Need to talk to, inorder to get a cool hat.
	SNAKE,
	# Can talk to, to get to the exit.
	RAT,
	# Need to talk to, inorder to get a cool hat.
	HATTER,
}


# Booleans & Other data Related to the "story" of the sewer.
var has_snake: bool = false
var soda_count: int = 0
var map_state := MapState.INTRO
var action_state := ActionType.MOVEMENT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("UP"):
		action_state = ActionType.MOVEMENT
		$Player.animation_type = GameTypes.MovementState.NORTH_EAST
	elif Input.is_action_pressed("DOWN"):
		action_state = ActionType.MOVEMENT
		$Player.animation_type = GameTypes.MovementState.SOUTH_WEST
	elif Input.is_action_pressed("RIGHT"):
		action_state = ActionType.MOVEMENT
		$Player.animation_type = GameTypes.MovementState.SOUTH_EAST
	elif Input.is_action_pressed("LEFT"):
		action_state = ActionType.MOVEMENT
		$Player.animation_type = GameTypes.MovementState.NORTH_WEST
	elif Input.is_action_pressed("INTERACT"):
		action_state = ActionType.INTERACT
	elif Input.is_action_pressed("Jump"):
		action_state = ActionType.SKIP_DIALOGUE
	elif Input.is_action_pressed("esc"):
		action_state = ActionType.SETTINGS
	else:
		action_state = ActionType.MOVEMENT
		$Player.animation_type = GameTypes.MovementState.IDLE



func handle_dialogue():
	pass

# Handling all PlayerInput, setting resulting value to enum. Atleast in the
# wednesday "game" input should not be handled anywhere else.
#
