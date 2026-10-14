## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Description:
## 	Describe all states & types that both the game scene & player scene will use.
##

## Name:
## 	DeathTypes
##
## Purpose:
## 	Describe the various types of death animations that the player might go
## 	through, all death types will be passed from the game, for the player script
## 	and scene to animate.
##
## Members:
## 	DEATH_BY_SNAKE     -> if you don't take the snake.
## 	DEATH_BY_RAT       -> if you arn't nice to the rat.
## 	DEATH_BY_DARKNESS  -> if the battery runs out of charge.
##
enum DeathTypes {
	DEATH_BY_SNAKE,
	DEATH_BY_RAT,
	DEATH_BY_DARKNESS,
}

## Name:
## 	ItemTypes
##
## Purpose:
## 	This is a nice to have, and may not be in the final game. It describes the
## 	different types of items that might be found in the game.
##
## Members:
## 	SODA
## 	SNAKE
## 	SNAKE_SKIN_HAT
##
enum ItemTypes {
	SODA,
	SNAKE,
	SNAKE_SKIN_HAT,
}

## Name:
## 	MovementState
##
## Purpose:
## 	Provide an easy way for the GameScene to tell the player what type of
## 	movement to use.
##
## Members:
## 	IDLE         -> Default/No Buttons Pressed
## 	NORTH_WEST   -> KEY_A Pressed || LEFT_ARROW
## 	NORTH_EAST   -> KEY_W Pressed || UP_ARROW
## 	SOUTH_WEST   -> KEY_D Pressed || RIGHT_ARROW
## 	SOUTH_EAST   -> KEY_S Pressed || DOWN_ARROW
##
enum MovementState {
	IDLE,
	NORTH_WEST,
	NORTH_EAST,
	SOUTH_WEST,
	SOUTH_EAST,
}

## Name:
## 	BatteryState
##
## Description:
## 	Using in place of a health bar, the player is using their phone's flashlight
## 	and must escape before they run out of battery.
##
## Members:
## 	FULL      -> Full when player spawns in.
## 	HALF      -> Halfway finished.
## 	QUARTER   -> Battery in it's final stages of being alive
## 	EMPTY     -> Battery is dead, and so is the player
##
enum BatteryState {
	FULL,
	HALF,
	QUARTER,
	EMPTY,
}
