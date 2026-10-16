extends CharacterBody2D
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

#region Loading Resources
##
## Loading GameTypes Script for easier communication between the game scene and
## player scene.
##
const GameTypes := preload("res://Scripts/Tuesday/game_types.gd")
#endregion

#region Default Values
##
## Setting Default Animation
##
const ANIMATION_DEFAULT := GameTypes.MovementState.IDLE

##
## Setting Player Walk Speed
##
const SPEED: float = 3200
#endregion

#region Global Variables
##
## Global for changing the type of animation that gets rendered
##
var animation_type: GameTypes.MovementState

## Global for storing the amounts of items in the Player's inventory
var inventory: Dictionary[GameTypes.ItemTypes, int] \
= {                                                 \
	GameTypes.ItemTypes.SNAKE : 0,                  \
	GameTypes.ItemTypes.SODA : 0,                   \
	GameTypes.ItemTypes.SNAKE_SKIN_HAT : 0          \
}
#endregion

#region Inventory Functions
##
## Name:
## 	has_item
##
## Description:
## 	checks if the player has an item in their inventory
##
## Parameters:
## 	item: [GameTypes.ItemTypes] -> The type of item the player might have.
## 
## Returns:
## 	has_item: [bool] -> true if the player has the item
## 					 -> false if the player does not have the item.
##
## Errors:
## 	None
##
func has_item(item: GameTypes.ItemTypes) -> bool:
	var has_item: bool = inventory.get(item) > 0
	return has_item

##
## Name:
## 	add_item
##
## Description:
## 	adds an item to the player's inventory
##
## Parameters:
## 	item: [GameTypes.ItemTypes] -> The type of item the player picked up.
## 
## Returns:
## 	void
##
## Errors:
## 	None
##
func add_item(item: GameTypes.ItemTypes) -> void:
	inventory[item] += 1

##
## Name:
## 	clear_inventory
##
## Description:
## 	reset's all values in the player's inventory to zero.
##
## Parameters:
## 	None
## 
## Returns:
## 	Nothing
##
## Errors:
## 	None
##
func clear_inventory() -> void:
	for item in inventory:
		item = 0
#endregion

#region Node Functions
##
## Name:
## 	_ready
##
## Description:
## 	called when node enters scene tree. sets animation_type to idle,
## 	sets the animation sprite to play the default animation which is idle.
## 	clear's the players inventory (in case this is their first go-around).
##
## Parameters:
## 	None
## 
## Returns:
## 	Nothing
##
## Errors:
## 	None
##
func _ready() -> void:
	animation_type = GameTypes.MovementState.IDLE
	$AnimatedSprite2D.play("default")
	clear_inventory()
#endregion

#region Player Movement
##
## Borrowed from GDQuest guide: 
## 
## Name:
## 	cartesian_to_isometric
##
## Description:
## 	Converts godot's default cartesain movement type into one suited for
## 	isometric games.
##
## Parameters:
## 	cartesian: [Vector2] -> The original coordinates.
## 
## Returns:
## 	isometric: [Vector2] -> The coordinates converted into isometric form.
##
func cartesian_to_isometric(cartesian: Vector2) -> Vector2:
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)

## 
## Name:
## 	_physics_process
##
## Description:
## 	Sets player's animation to the correct one, and moves the player if 
##  given a MovementState that is not the default (idle)
##
## Parameters:
## 	cartesian: [Vector2] -> The original coordinates.
## 
## Returns:
## 	isometric: [Vector2] -> The coordinates converted into isometric form.
##
func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	var movement: Vector2 = Vector2.ZERO
	match animation_type:
		# Move "up"
		GameTypes.MovementState.NORTH_EAST:
			$AnimatedSprite2D.play("Northeast")
			direction += Vector2(0, -1)
		# Move "down"
		GameTypes.MovementState.SOUTH_WEST:
			$AnimatedSprite2D.play("Southwest")
			direction += Vector2(0, 1)
		# Move "left"
		GameTypes.MovementState.NORTH_WEST:
			$AnimatedSprite2D.play("Northwest")
			direction += Vector2(-1, 0)
		# Move "right"
		GameTypes.MovementState.SOUTH_EAST:
			$AnimatedSprite2D.play("Southeast")
			direction += Vector2(1, 0)
		# Don't move.
		GameTypes.MovementState.IDLE:
			$AnimatedSprite2D.play("default")
			direction = Vector2.ZERO
		
	movement = direction.normalized() * SPEED * delta
	velocity = cartesian_to_isometric(movement)
	move_and_slide()
#endregion
