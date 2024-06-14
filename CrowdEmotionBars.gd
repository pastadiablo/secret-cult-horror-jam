extends HBoxContainer

@export var angerBar: ProgressBar
@export var despairBar: ProgressBar
@export var fearBar: ProgressBar

@export var angerAmplified: Control
@export var angerSuppressed: Control
@export var despairAmplified: Control
@export var despairSuppressed: Control
@export var fearAmplified: Control
@export var fearSuppressed: Control

@export var angerMultiplierLabel: Label
@export var despairMultiplierLabel: Label
@export var fearMultiplierLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
