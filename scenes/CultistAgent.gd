@tool
class_name CultistAgent extends Node2D

@export var cultist: Cultist
@export var sprite: Sprite2D
@export var button: Button
@export var animationPlayer: AnimationPlayer
@export var animationTree: AnimationTree

var _stateMachine: AnimationNodeStateMachinePlayback

static var textures: Dictionary

static func Create(cultist):
	var agent = load("res://scenes/CultistAgent.tscn").instantiate()
	agent.cultist = cultist
	return agent
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = cultist.position
	if textures.is_empty():
		textures = {
			CultConstants.Emotion.NONE: load("res://resources/textures/BaseCultist.png"),
			CultConstants.Emotion.FEAR: load("res://resources/textures/FearCultist.png"),
			CultConstants.Emotion.ANGER: load("res://resources/textures/AngerCultist.png"),
			CultConstants.Emotion.DESPAIR: load("res://resources/textures/DespairCultist.png")
		}
	button.pressed.connect(SacrificeCultist)
	_stateMachine = animationTree["parameters/playback"]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sprite.texture.atlas != textures[cultist.emotion]:
		sprite.texture.atlas = textures[cultist.emotion]
		print("Setting new atlas: " + sprite.texture.atlas.resource_path)
	
	pass
	
func SacrificeCultist() -> void:
	_stateMachine.travel("soul_idle")
	button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	pass
