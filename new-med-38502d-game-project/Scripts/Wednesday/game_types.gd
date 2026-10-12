# @Author: James Huston
# @Email:  huston@uleth.ca
#
# @Purpose:
# 	Describe all states & types that both the game scene & player scene will use.
#

# For the game to pass to the player, and the player to animate
enum DeathTypes {
	DEATH_BY_SNAKE,
	DEATH_BY_RAT,
	DEATH_BY_DARKNESS,
	DEATH_BY_BATTERY
}

# **nice to have** but am leaving it here incase if future james has more time.
enum ItemTypes {
	SODA,
	SNAKE,
	SNAKE_SKIN_HAT,
}

# To be used by the game scene (sending state type to player) instead of the player
# and game scene handling input checking.
enum MovementState {
	# Default/No Buttons Pressed.
	IDLE,
	# KEY_A Pressed || LEFT_ARROW
	NORTH_WEST,
	# KEY_W Pressed || UP_ARROW
	NORTH_EAST,
	# KEY_D Pressed || RIGHT_ARROW
	SOUTH_WEST,
	# KEY_S Pressed || DOWN_ARROW
	SOUTH_EAST,
}
