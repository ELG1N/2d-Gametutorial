extends Node2D
## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Description:
## 	Manage all data, functions, signals, children related to the thursday game
##

#region Game States
enum SingleDialogueState {
	LOUD,
	SILENT,
}
#endregion


#region Resources
const DIALOGUE_ENGINE: Resource \
= preload("res://Scripts/Tuesday/dialogue_engine.gd")


var DIALOGUE: Dictionary \
= DIALOGUE_ENGINE.load_dialogue_from_path("res://Assets/Data/Thursday/thursday_dialogue.json")
#endregion

#region Default Values
const DEFAULT_SINGLE_DIALOGUE_STATE: SingleDialogueState \
= SingleDialogueState.SILENT

const DEFAULT_PLAYER_HEALTH: float \
= 100
#endregion

#region Global Variables
##
## Global variable for managine the level of the battery, this is serving as a
## pseudo healthbar for the player.
##
var bplayer_health: float \
= DEFAULT_PLAYER_HEALTH

var single_dialogue_state: SingleDialogueState \
= DEFAULT_SINGLE_DIALOGUE_STATE

#endregion

#region Node Functions

func _ready() -> void:
	single_dialogue_state = SingleDialogueState.LOUD
	%SingleDialogueView.show_and_start_timer(DIALOGUE["intro"])

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Jump"):
		%SingleDialogueView.skip_dialogue()
	elif Input.is_action_pressed("esc"):
		pass
#endregion




func death():
	single_dialogue_state = SingleDialogueState.LOUD
	%SingleDialogueView.show_and_start_timer(DIALOGUE["death"])
	await %SingleDialogueView.dialogue_end
	get_tree().reload_current_scene()


#region Signals & Events
func _on_single_dialogue_view_dialogue_end() -> void:
	single_dialogue_state = SingleDialogueState.SILENT
#endregion


func _on_ending_area_entered(area: Area2D) -> void:
	single_dialogue_state = SingleDialogueState.LOUD
	%SingleDialogueView.show_and_start_timer(DIALOGUE["finish"])
	await %SingleDialogueView.dialogue_end


var h1_received = false
func _on_health_1_area_entered(area: Area2D) -> void:
	if h1_received == true:
		%SingleDialogueView.show_and_start_timer(DIALOGUE["rbeer"])
		await %SingleDialogueView.dialogue_end
		h1_received = true
		%Health1.hide()
		%Player.heal()

var h2_received = false
func _on_health_2_area_entered(area: Area2D) -> void:
	if h2_received == true:
		%SingleDialogueView.show_and_start_timer(DIALOGUE["ccola"])
		await %SingleDialogueView.dialogue_end
		h2_received = true
		%Health2.hide()
		%Player.heal()


func _on_player_dead() -> void:
	death()
