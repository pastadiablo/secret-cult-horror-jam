class_name Dialogue extends Resource



enum Duration {
	
}
enum Behavior {
	FORCE, # Forced to stay on screen until an input is received
	LINGER, # Stays on screen until next dialogue is available
	DISSIPATE, # Leaves the screen even if there is no dialogue coming
}

@export var dialogue: String

#total seconds to display
@export var speed: float

#how long to linger the text for
@export var lingerSpeed: float

#
@export var makeWayAlways: bool
