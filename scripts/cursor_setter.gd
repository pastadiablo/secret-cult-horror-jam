extends Node


func _ready():
	Input.set_custom_mouse_cursor(load("res://resources/cursors/HandPoint.png"), Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(load("res://resources/cursors/HandGrab.png"), Input.CURSOR_DRAG)
	pass
