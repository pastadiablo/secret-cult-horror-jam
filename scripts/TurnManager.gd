@tool
class_name TurnManager extends Node

enum TurnPhase {
	ACTION,
	PLAY,
	WAIT,
}

var turn: int = 0
@export var currentPhase: TurnPhase = TurnPhase.WAIT:
	set(value):
		currentPhase = value
		_updateControlsForCurrentPhase()


@export var turnActionControl: Control
@export var endTurnControl: Control
@export var entityActionLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func StartTurn():
	if currentPhase != TurnPhase.WAIT: return
	currentPhase = TurnPhase.ACTION
	SummoningBoard.instance.summoning.sacrifices = 0

func EndTurn():
	if currentPhase != TurnPhase.PLAY: return
	currentPhase = TurnPhase.WAIT

func _updateControlsForCurrentPhase():
	if !endTurnControl || !turnActionControl || !entityActionLabel: return
	match currentPhase:
		TurnPhase.ACTION: 
			endTurnControl.visible = false
			turnActionControl.visible = true
			entityActionLabel.visible = false
		TurnPhase.PLAY:
			endTurnControl.visible = true
			turnActionControl.visible = false
			entityActionLabel.visible = false
			pass
		TurnPhase.WAIT:
			endTurnControl.visible = false
			turnActionControl.visible = false
			entityActionLabel.visible = true
			pass
