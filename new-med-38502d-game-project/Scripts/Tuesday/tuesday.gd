extends Node2D
## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Description:
## 	Manage all data related to the player, receives information about events
## 	taking place within the game scene from the game script and react
## 	accordingly
##

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
	SEWER,
	SCHOOL,
}

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

## Loading the GameTypes Script, to get the various enums required for
## communication with the player scene.
const GameTypes: Resource = preload("res://Scripts/Tuesday/game_types.gd")

## Loading the DialogueEngine, needed for getting json data that describes
## dialogue.
const DialogueEngine: Resource = preload("res://Scripts/Tuesday/dialogue_engine.gd")

## Constant describing maximum battery charge.
const MAX_BATTERY_CHARGE: float = 100

# Booleans & Other data Related to the "story" of the sewer, may track in an
# map later, but for now variables are good enough.
var has_snake: bool = false
var soda_count: int = 0
var battery_charge: float = 100
var map_state := MapState.INTRO
var action_state := ActionType.MOVEMENT
var dialogue: Dictionary = DialogueEngine.load_dialogue_from_path("res://Assets/Data/Tuesday/dialogue.json")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%BatteryCharge.hide()
	%BatteryCharge._reset()
	battery_charge = MAX_BATTERY_CHARGE
	print(dialogue["intro"])

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

func _on_battery_drain_timer_timeout() -> void:
	battery_charge -= 1
	%BatteryCharge._update(battery_charge)

# Handling all PlayerInput, setting resulting value to enum. Atleast in the
# wednesday "game" input should not be handled anywhere else.
#
func _on_true_exit_door_area_entered(area: Area2D) -> void:
	print("YIPPEE, you've made it to the university")
	

func _on_sewer_spawn_area_entered(area: Area2D) -> void:
	# need to check if player was not initally in the
	# sewer so that the battery drain timer does not get
	# reset.
	if map_state != MapState.SEWER:
		map_state = MapState.SEWER
		%BatteryCharge.show()
		%BatteryDrainTimer.start()


func _on_fake_exit_door_area_entered(area: Area2D) -> void:
	print("Shit, I can't exit here")
