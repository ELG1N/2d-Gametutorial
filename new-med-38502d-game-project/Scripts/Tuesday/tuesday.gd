extends Node2D
## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Description:
## 	Manage all data, functions, signals, children related to the game
##

#region Game States
##
## Name:
## 	MapState
##
## Purpose:
## 	Provide states to track which part of the game the player is in, which will
## 	help with showing different scenes, aswell as making some of the code
## 	easier to understand.
##
## Members:
## 	INTRO    -> Brief tutorial on what controls move the player.
## 	SEWER    -> Middle Scene, player must escape the labyrinth, that is the
## 			 	sewer inorder to escape.
## 	SCHOOL   -> Final Scene, player wins this day if they make it here.
##
enum MapState {
	INTRO,
	SEWER_ENTERED,
	SEWER_COMMITED,
	SCHOOL,
}

##
## Name:
## 	SingleDialogueState
##
## Purpose:
## 	Povide an easy way to track the status of single dialogue in the game
##
## Members:
## 	LOUD -> The dialogue is playing
## 	SILENT -> The dialogue has finished
##
enum SingleDialogueState {
	LOUD,
	SILENT,
}

##
## Name:
## 	MultiDialogueState
##
## Purpose:
## 	Povide an easy way to track the status of multi dialogue in the game
##
## Members:
## 	LOUD -> The dialogue is playing
## 	SILENT -> The dialogue has finished
##
enum MultiDialogueState {
	LOUD,
	SILENT,
}
#endregion

#region Game Types Local to Game
##
## Name:
## 	ActionType
##
## Purpose:
## 	Actions either relating to this particular game scene that the player
## 	doesn't really need to handle, or in the case of SETTINGS, the game as a
## 	whole.
##
## Members:
## 	MOVEMENT        -> Default/No-Recognized Buttons Pressed.
## 	INTERACT        -> KEY_E Pressed
## 	SETTINGS        -> KEY_ESCAPE Pressed
## 	SKIP_DIALOGUE   -> KEY_SPACE Pressed
##
enum ActionType {
	MOVEMENT,
	INTERACT,
	SETTINGS,
	SKIP_DIALOGUE,
}

##
## Name:
## 	NPCType
##
## Purpose:
## 	If I have enough time I'll develop this idea of npc's further, for now
## 	though, this one will state unused.
##
## Members:
## 	SNAKE    -> Need to talk to, inorder to get a cool hat.
## 	RAT      -> Can talk to, to get to the exit.
## 	HATTER   -> Need to talk to, inorder to get a cool hat.
##
enum NPCType {
	SNAKE,
	RAT,
	HATTER,
}
#endregion

#region Resources
##
## Loading the GAME_TYPES Script, to get the various enums required for
## communication with the player scene, and dialogue scenes.
##
const GAME_TYPES: Resource \
= preload("res://Scripts/Tuesday/game_types.gd")

##
## Loading the DialogueEngine, needed for getting json data that describes
## dialogue.
##
const DIALOGUE_ENGINE: Resource \
= preload("res://Scripts/Tuesday/dialogue_engine.gd")

##
## 	Constants are unfortunately compile time variables so I actually cannot make
## 	this value immutable on run time, it I wanted to do that I would need to
## 	apply _make_read_only() recursively on all dictionary entries - which for
## 	this project there's really no point. Instead I will be putting it with
## 	the other resources as a sort of reminder. 
##
var DIALOGUE: Dictionary \
= DIALOGUE_ENGINE.load_dialogue_from_path("res://Assets/Data/Tuesday/dialogue.json")
#endregion

#region Default Values
##
##	Default Map State, where the player is initially loaded into at the start
##	of the game.
##
const DEFAULT_MAP_STATE: MapState \
= MapState.INTRO

##
##	Default ActionType
##
const DEFAULT_ACTION_TYPE: ActionType \
= ActionType.MOVEMENT

##
## Default Single Dialogue State
##
const DEFAULT_SINGLE_DIALOGUE_STATE: SingleDialogueState \
= SingleDialogueState.SILENT

##
## Default Multi Dialogue State
##
const DEFAULT_MULTI_DIALOGUE_STATE: MultiDialogueState \
= MultiDialogueState.SILENT

##
## Default Battery Charge
##
const DEFAULT_BATTERY_CHARGE: float \
= 100
#endregion

#region Global Variables
##
## Global variable for managine the level of the battery, this is serving as a
## pseudo healthbar for the player.
##
var battery_charge: float \
= DEFAULT_BATTERY_CHARGE

##
## Global state tracker for relative player position in the map, helps to
## trigger events in places where signals won't be easy to implement.
##
var map_state: MapState \
= DEFAULT_MAP_STATE

##
## Global action type value for handling when the player inputs different
## types of actions and different scripts need to handle each one.
##
var action_type: ActionType \
= DEFAULT_ACTION_TYPE

##
## Global state for dialogue system, this is just easier than making a bool
## in every function that uses a dialogue view. It is the same reasoning for
## both single and multi state.
##
var single_dialogue_state: SingleDialogueState \
= DEFAULT_SINGLE_DIALOGUE_STATE

var multi_dialogue_state: MultiDialogueState \
= DEFAULT_MULTI_DIALOGUE_STATE
#endregion

#region Node Functions
##
## Name:
## 	_ready
##
## Description:
## 	the first function to run when the game scene is loaded into the scene tree
## 	sets the player position to the intro spawn location, sets all variables
## 	related to the darkness effect to hidden, because they're not needed yet,
## 	(i.e. pointlight2d, canvasmodulate, backgound and battery), play intro
## 	dialogue.
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
	%Player.global_position = %Spawn/Intro.global_position
	%Player/Flashlight.hide()
	%World/CanvasModulate.hide()
	%World/Background.hide()
	%BatteryCharge.hide()
	battery_charge = DEFAULT_BATTERY_CHARGE
	%SingleDialogueView.update_box(GAME_TYPES.DialogueBoxSizes.MEDIUM, DIALOGUE["intro"])
	%SingleDialogueView.show_and_start_timer()

##
## Name:
## 	_process
##
## Description:
## 	handles all user input, calls the scripts/functions related to each input,
## 	i.e. dialogue skipping, player movement and interaction (though there is no
## 	interaction events created as of yet, they should be pretty easy to
## 	implement.
##
## Parameters:
## 	_delta: [float] -> ignored
##
## Returns:
## 	void
##
## Errors:
## 	None
##
func _process(_delta: float) -> void:
	if map_state == MapState.INTRO:
		%Manhole.position.x = %Player.position.x
	if Input.is_action_pressed("UP"):
		action_type = ActionType.MOVEMENT
		$Player.animation_type = GAME_TYPES.MovementState.NORTH_EAST
	elif Input.is_action_pressed("DOWN"):
		action_type = ActionType.MOVEMENT
		$Player.animation_type = GAME_TYPES.MovementState.SOUTH_WEST
	elif Input.is_action_pressed("RIGHT"):
		action_type = ActionType.MOVEMENT
		$Player.animation_type = GAME_TYPES.MovementState.SOUTH_EAST
	elif Input.is_action_pressed("LEFT"):
		action_type = ActionType.MOVEMENT
		$Player.animation_type = GAME_TYPES.MovementState.NORTH_WEST
	elif Input.is_action_pressed("INTERACT"):
		action_type = ActionType.INTERACT
	elif Input.is_action_pressed("Jump"):
		action_type = ActionType.SKIP_DIALOGUE
		if %SingleDialogueView.visible:
			%SingleDialogueView.skip_dialogue()
	elif Input.is_action_pressed("esc"):
		action_type = ActionType.SETTINGS
	else:
		action_type = ActionType.MOVEMENT
		$Player.animation_type = GAME_TYPES.MovementState.IDLE
#endregion

#region Signals & Events

##TODO: Comment
func _on_battery_drain_timer_timeout() -> void:
	battery_charge -= 1
	%BatteryCharge._update(battery_charge)

##TODO: Comment
func _on_true_exit_door_area_entered(area: Area2D) -> void:
	%Player.global_position = %Spawn/School.global_position
	%World/CanvasModulate.visible = false
	%World/Background.visible = false
	%Player/Flashlight.visible = false
	print("YIPPEE, you've made it to the university")

##TODO: Comment
func _on_sewer_spawn_area_entered(area: Area2D) -> void:
	# need to check if player was not initally in the
	# sewer so that the battery drain timer does not get
	# reset.
	if map_state != MapState.SEWER_COMMITED:
		map_state = MapState.SEWER_COMMITED
		%BatteryCharge.show()
		%BatteryDrainTimer.start()
		%Player/Flashlight.visible = true

##TODO: Comment
func _on_fake_exit_door_area_entered(area: Area2D) -> void:
	print("Oh no, the bars are too rusty, I can't exit here")

##TODO: Comment
func _on_manhole_area_entered(area: Area2D) -> void:
	if single_dialogue_state == SingleDialogueState.SILENT:
		%Player.global_position = %Spawn/Sewer.global_position
		single_dialogue_state = SingleDialogueState.LOUD
		%World/CanvasModulate.visible = true
		%World/Background.visible = true
		map_state = MapState.SEWER_ENTERED

##TODO: Comment
func _on_single_dialogue_view_dialogue_end() -> void:
	single_dialogue_state = SingleDialogueState.SILENT

#endregion
