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
	angerBar.value = CrowdManager.emotions[CultConstants.Emotion.ANGER]
	despairBar.value = CrowdManager.emotions[CultConstants.Emotion.DESPAIR]
	fearBar.value = CrowdManager.emotions[CultConstants.Emotion.FEAR]
	var angerMultiplier = CrowdManager.nextCardMultiplier[CultConstants.Emotion.ANGER]
	var despairMultiplier = CrowdManager.nextCardMultiplier[CultConstants.Emotion.DESPAIR]
	var fearMultiplier = CrowdManager.nextCardMultiplier[CultConstants.Emotion.FEAR]
	
	angerAmplified.visible = angerMultiplier > 1.0
	angerSuppressed.visible = angerMultiplier < 1.0
	angerMultiplierLabel.visible = angerMultiplier != 1.0
	angerMultiplierLabel.text = "%d%%" % snapped(angerMultiplier * 100, 1.0)
	
	despairAmplified.visible = despairMultiplier > 1.0
	despairSuppressed.visible = despairMultiplier < 1.0
	despairMultiplierLabel.visible = despairMultiplier != 1.0
	despairMultiplierLabel.text = "%d%%" % snapped(despairMultiplier * 100, 1.0)
	
	fearAmplified.visible = fearMultiplier > 1.0
	fearSuppressed.visible = fearMultiplier < 1.0
	fearMultiplierLabel.visible = fearMultiplier != 1.0
	fearMultiplierLabel.text = "%d%%" % snapped(fearMultiplier * 100, 1.0)
