class_name EntityAgent extends Node2D

@export var entity: Entity
@export var sprite: Sprite2D
@export var animationPlayer: AnimationPlayer
@export var animationTree: AnimationTree
@export var growlPlayer: AudioStreamPlayer

var _stateMachine: AnimationNodeStateMachinePlayback

static func Create(entityPath):
	var agent = load(entityPath).instantiate()
	return agent
	
func _ready() -> void:
	_stateMachine = animationTree["parameters/playback"]
	_stateMachine.travel(&"idle")

func _process(delta: float) -> void:
	pass

func _conversation(turn: int) -> String:
	var conversation = ""
	if turn == 1: conversation = entity.greeting
	growlPlayer.play()
	_stateMachine.travel("attack")
	conversation = entity.converse.pick_random()
	return conversation

func _actOnTurn(turn: int) -> void:
	push_error("Not Implemented Yet")
	
func _bindEntity() -> String:
	growlPlayer.play()
	return entity.plead
	
func _entitySubmits() -> String:
	growlPlayer.play()
	return entity.submit

func _entityVictorious() -> String:
	growlPlayer.play()
	return entity.victory
	
