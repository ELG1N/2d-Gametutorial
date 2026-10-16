extends Control
## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Purpose:
## 	Provide functions to update and reset the visual state of the battery.
##

##
## Constant for the player health, makes it easier for resetting, and avoiding
## magic numbers.
##
const MAX_BATTERY_CHARGE: float = 100


##
## Name:
## 	_ready
##
## Description:
## 	Called when the node enters the scene tree for the first time, sets the
## 	progress bar value to 100, which is the maximum charge the phone battery
## 	can have.
##
## Parameters:
## 	None
##
## Returns:
## 	Void
##
## Errors:
## 	None
##
func _ready() -> void:
	$TextureProgressBar.value = MAX_BATTERY_CHARGE

##
## Name:
## 	_reset
##
## Description:
## 	Resets the value of the progress bar back to it's max.
##
## Parameters:
## 	None
##
## Returns:
## 	Void
##
## Errors:
## 	None
##
func _reset() -> void:
	$TextureProgressBar.value = MAX_BATTERY_CHARGE

##
## Name:
## 	_ready
##
## Description:
## 	Updates the progress bar value to the value provided as a parameter.
##
## Parameters:
## 	new_charge: [float] -> The new value for the progress bar to be set to.
##
## Returns:
## 	Void
##
## Errors:
## 	None
##
func _update(new_charge: float) -> void:
	$TextureProgressBar.value = new_charge
