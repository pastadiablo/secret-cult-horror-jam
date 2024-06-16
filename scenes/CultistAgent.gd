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

var _hovering: bool = false
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
	ResetAnimation()
	#button.mouse_entered.connect(_mouse_entered)
	#button.mouse_exited.connect(_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	button.visible = SummoningBoard.instance.CanSacrifice(self)
	if !sprite.texture: return
	if sprite.texture.atlas != textures[cultist.emotion]:
		sprite.texture.atlas = textures[cultist.emotion]	
	pass

func _input(event: InputEvent):
	#if TurnManager.instance.currentPhase != TurnManager.TurnPhase.PLAY: return
	if event is InputEventMouseMotion:
		var motion: InputEventMouseMotion = event
		if button.get_global_rect().has_point(motion.global_position):
			if !_hovering:
				_mouse_entered()
			_hovering = true
		else:
			if _hovering:
				_mouse_exited()
			_hovering = false

func _mouse_entered():
	if cultist.state != Cultist.State.ALIVE: return
	DanceAnimation()
	sprite.material.set("shader_parameter/width", 1)
	EnteringCultist.emit(self)

func _mouse_exited():
	if cultist.state != Cultist.State.ALIVE: return
	ResetAnimation()
	sprite.material.set("shader_parameter/width", 0)
	ExitingCultist.emit(self)

func SacrificeCultist() -> void:
	if cultist.state != Cultist.State.ALIVE: return
	SummoningBoard.instance.summoning.sacrifices -= 1
	sprite.material.set("shader_parameter/width", 0)
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
