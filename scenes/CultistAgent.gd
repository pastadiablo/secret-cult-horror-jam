@tool
class_name CultistAgent extends Node2D

signal Sacrificed(agent: CultistAgent)
signal Consumed(agent: CultistAgent)
signal EnteringCultist(agent: CultistAgent)
signal ExitingCultist(agent: CultistAgent)

@export var cultist: Cultist
@export var sprite: Sprite2D
@export var button: Button
@export var animationPlayer: AnimationPlayer
@export var animationTree: AnimationTree

@export var playerTurn: bool:
	set(value): 
		playerTurn = value
		ResetAnimation()

var _stateMachine: AnimationNodeStateMachinePlayback

static var textures: Dictionary

static func Create(cultist):
	var agent = load("res://scenes/CultistAgent.tscn").instantiate()
	agent.cultist = cultist
	return agent
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if textures.is_empty():
		textures = {
			CultConstants.Emotion.NONE: load("res://resources/textures/BaseCultist.png"),
			CultConstants.Emotion.FEAR: load("res://resources/textures/FearCultist.png"),
			CultConstants.Emotion.ANGER: load("res://resources/textures/AngerCultist.png"),
			CultConstants.Emotion.DESPAIR: load("res://resources/textures/DespairCultist.png")
		}
	button.pressed.connect(SacrificeCultist)
	_stateMachine = animationTree["parameters/playback"]
	button.mouse_entered.connect(DanceAnimation)
	button.mouse_exited.connect(ResetAnimation)
	ResetAnimation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sprite.texture.atlas != textures[cultist.emotion]:
		sprite.texture.atlas = textures[cultist.emotion]	
	pass

func _mouse_entered():
	DanceAnimation()
	EnteringCultist.emit(self)

func _mouse_exited():
	ResetAnimation()
	ExitingCultist.emit(self)

func SacrificeCultist() -> void:
	if cultist.state != Cultist.State.ALIVE: return
	_stateMachine.travel(&"soul_idle")
	cultist.state = Cultist.State.SACRIFICED
	button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	Sacrificed.emit(self)

func ConsumeSoul() -> void:
	if (cultist.state == Cultist.State.SACRIFICED):
		_stateMachine.travel(&"soul_consume")		
	cultist.state = Cultist.State.DEAD
	button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	Consumed.emit(self)
	pass

func ResetAnimation() -> void:
	if _stateMachine:
		ChantAnimation() if playerTurn else IdleAnimation()

func IdleAnimation() -> void:
	if cultist.state == Cultist.State.ALIVE:
		_stateMachine.travel(&"idle")

func ChantAnimation() -> void:
	if cultist.state == Cultist.State.ALIVE:
		_stateMachine.travel(&"chant")

func DanceAnimation() -> void:
	if cultist.state == Cultist.State.ALIVE:
		_stateMachine.travel(&"ritual")
