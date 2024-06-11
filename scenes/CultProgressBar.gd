@tool
extends Control

@export var underTexture: Texture2D
@export var progressTexture: Texture2D
@export var overTexture: Texture2D

@export_range(0.0, 1.0) var progress: float = 0.0:
	set(value): 
		progress = clamp(value, 0.0, 1.0)
		progressBar.custom_minimum_size = Vector2(progressBar.custom_minimum_size.x, floor(progress * size.y))

var underBar: NinePatchRect
var progressBar: NinePatchRect
var overBar: NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	underBar = get_child(0)
	progressBar = get_child(1)
	overBar = get_child(2)
	
	underBar.texture = underTexture
	progressBar.texture = progressTexture
	overBar.texture = overTexture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
