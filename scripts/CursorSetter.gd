extends Node


func _ready():
	Input.set_custom_mouse_cursor(load("res://resources/cursors/HandArrow.png"), Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(load("res://resources/cursors/HandPoint.png"), Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(load("res://resources/cursors/HandGrab.png"), Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(load("res://resources/cursors/HandKnife.png"), Input.CURSOR_FORBIDDEN)
	pass
