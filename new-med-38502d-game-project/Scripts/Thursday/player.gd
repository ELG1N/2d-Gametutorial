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

signal dead

#region Default Values
##
## Setting Player Walk Speed
##
const SPEED: float = 4500
#endregion

#region Global Variables
var health: float = 250

var take_damage = true

#endregion

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
	$ProgressBar.show()
	$AnimatedSprite2D.play("IDLE")
	
func heal() -> void:
	health = 250


## 
## Name:
## 	_physics_process
##
## Description:
## 	Sets player's animation to the correct one, and moves the player if 
##  given a MovementState that is not the default (idle)
##
## Parameters:
## 
## Returns:
##
func _physics_process(delta: float) -> void:
	var directions = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN", 0)
	var x: float = directions.x
	var y: float = directions.y
	if directions.x > 0 and directions.y == 0:
		$AnimatedSprite2D.play("EAST")
	elif directions.x < 0 and directions.y == 0:
		$AnimatedSprite2D.play("WEST")
	elif directions.x == 0 and directions.y > 0:
		$AnimatedSprite2D.play("SOUTH")
	elif directions.x == 0 and directions.y < 0:
		$AnimatedSprite2D.play("NORTH")
	elif directions.x > 0 and directions.y > 0:
		$AnimatedSprite2D.play("SOUTHEAST")
	elif directions.x > 0 and directions.y < 0:
		$AnimatedSprite2D.play("NORTHEAST") # good
	elif directions.x < 0 and directions.y > 0:
		$AnimatedSprite2D.play("SOUTHWEST")
	elif directions.x < 0 and directions.y < 0:
		$AnimatedSprite2D.play("NORTHWEST")
	else:
		$AnimatedSprite2D.play("IDLE")

	velocity = directions * SPEED * delta
	move_and_slide()
	
	if health <= 0:
		dead.emit()
#endregion


func _on_time_between_hits_timeout() -> void:
	take_damage = true
	$TimeBetweenHits.stop()


func _on_hit_box_body_entered(enemy: Node2D) -> void:
	if take_damage:
		health -= 5
		take_damage = false
		$TimeBetweenHits.start()
		$ProgressBar.value = health
	
	
