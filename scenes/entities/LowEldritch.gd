extends EntityAgent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _actOnTurn(turn: int) -> void:
	if !SummoningBoard.instance || !TurnManager.instance: return
	var board := SummoningBoard.instance
	var turnManager := TurnManager.instance
	_stateMachine.travel("attack")
	var selection: CultistAgent = board.livingCultists.pick_random()
	selection.KillCultist(func():
		if Engine.is_editor_hint(): return
		turnManager.currentPhase = TurnManager.TurnPhase.NEXT_TURN
		_stateMachine.travel("idle")
	)
func _bindEntity():
	_stateMachine.travel("bind_idle")
	return super._bindEntity()
