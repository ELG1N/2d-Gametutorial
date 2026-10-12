extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# @Author: James Huston
# @Email:  huston@uleth.ca
#
# @Purpose:
# 	Describe all states & types that both the game scene & player scene will use.
#

const GameTypes := preload("res://Scripts/Wednesday/game_types.gd")

#
# Constants/Defaults
#
const MAX_BATTERY: float = 100
const ANIMATION_DEFAULT := GameTypes.MovementState.IDLE



#
# Variables Associated with Player
#
var animation_type: GameTypes.MovementState
var battery_level: float = 100
var speed: float = 700
var motion: Vector2


var inventory: Dictionary[GameTypes.ItemTypes, int] = {GameTypes.ItemTypes.SNAKE : 0, GameTypes.ItemTypes.SODA : 0, GameTypes.ItemTypes.SNAKE_SKIN_HAT : 0 }




#
# Player Iventory
#

# Name:
# 	has_item
#
# Description:
# 	checks if the player has an item in their inventory
#
# Parameters:
# 	item: GameTypes.ItemTypes
# 
# Returns:
# 	bool
# 		true if player has the item
# 		false otherwise
#
func has_item(item: GameTypes.ItemTypes) -> bool:
	return inventory.get(item) > 0

# Name:
# 	add_item
#
# Description:
# 	adds an item to the player's inventory
#
# Parameters:
# 	item: GameTypes.ItemTypes
# 
# Returns:
# 	void
#
func add_item(item: GameTypes.ItemTypes) -> void:
	inventory[item] += 1

# Name:
# 	clear_inventory
#
# Description:
# 	reset's all values in the player's inventory to zero.
#
# Parameters:
# 	None
# 
# Returns:
# 	Nothing
#
func clear_inventory() -> void:
	for item in inventory:
		item = 0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_type = GameTypes.MovementState.IDLE
	$AnimatedSprite2D.play("default")
	clear_inventory()
	battery_level = MAX_BATTERY

# Name:
# 	pause
#
# Description:
# 	Pause timer's related to the player when signaled by the wednesday game scene
# 	reason for this is if we have a menu or settings, and I don't want the player
# 	to die while we are in settings.
#
# Parameters:
# 	None
# 
# Returns:
# 	void
#
func pause() -> void:
	pass


# Borrowed from GDQuest guide: 
# 
# Name:
# 	cartesian_to_isometric
#
# Description:
# 	
#
# Parameters:
# 	cartesian: Vector2
# 
# Returns:
# 	isometric: Vector2
#
func cartesian_to_isometric(cartesian: Vector2) -> Vector2:
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)
	
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
		
	movement = direction.normalized() * speed * delta
	velocity = cartesian_to_isometric(movement)
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
