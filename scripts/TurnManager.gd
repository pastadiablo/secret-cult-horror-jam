@tool
class_name TurnManager extends Node

enum TurnPhase {
	ACTION,
	PLAY,
	ENTITY,
	END
}

@export var turn: int = 0
static var instance: TurnManager

@export var currentPhase: TurnPhase = TurnPhase.ENTITY:
	set(value):
		currentPhase = value
		_updateStateForCurrentPhase()

@export_group("Export Assignments")
@export var modalPanel: PanelContainer
@export var actionContainer: Container
@export var gainSacrificeButton: Button
@export var drawCardButton: Button
@export var endTurnButton: Button

@export_group("Event Label")
@export var eventLabel: Label
@export var textSpeed: float

@export_group("Turn Panel")
@export var turnPanelContainer: PanelContainer
@export var turnLabel: Label

@export_subgroup("Slide In Animation")
@export var slideStart: Vector2 = Vector2(-1300,250)
@export var slideInTime: float = 1.0
@export var slideInEase: Tween.EaseType
@export var slideInTransition: Tween.TransitionType
@export_subgroup("Slide Mid Animation")
@export var slideWait: float = 3.0
@export var slideMid: Vector2 = Vector2(-20, 250)
@export_subgroup("Slide Out Animation")
@export var slideOutTime: float = 1.0
@export var slideOutEase: Tween.EaseType
@export var slideOutTransition: Tween.TransitionType
@export var slideEnd: Vector2 = Vector2(1300, 250)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	turn = 0
	var playLambda = func(): 
		if currentPhase != TurnPhase.ACTION: return
		currentPhase = TurnPhase.PLAY
		
	gainSacrificeButton.pressed.connect(playLambda)
	drawCardButton.pressed.connect(playLambda)
	endTurnButton.pressed.connect(
		func(): 
			if currentPhase != TurnPhase.PLAY: return
			currentPhase = TurnPhase.ENTITY
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !eventLabel: return
	if eventLabel.visible_ratio < 1.0:
		eventLabel.visible_ratio += textSpeed * delta

func _updateStateForCurrentPhase():
	if !endTurnButton || !actionContainer || !modalPanel || !turnPanelContainer || !eventLabel: return
	match currentPhase:
		TurnPhase.ACTION:
			endTurnButton.visible = false
			actionContainer.visible = true
			modalPanel.visible = true
			turnPanelContainer.visible = false
			eventLabel.visible_ratio = 0
			eventLabel.text = "You must make a terrible choice..."
		TurnPhase.PLAY:
			endTurnButton.visible = true
			actionContainer.visible = false
			modalPanel.visible = false
			turnPanelContainer.visible = false
			eventLabel.visible_ratio = 0
			eventLabel.text = "Keep it bound!"
		TurnPhase.ENTITY:
			SummoningBoard.instance.summoning.sacrifices = 0
			endTurnButton.visible = false
			actionContainer.visible = false
			modalPanel.visible = true
			turnPanelContainer.visible = false
			eventLabel.visible_ratio = 0
			eventLabel.text = "The entity takes an action..."
			if Engine.is_editor_hint(): return
			var timer = get_tree().create_timer(5)
			timer.timeout.connect(func():currentPhase = TurnPhase.END)
		TurnPhase.END:
			turn += 1
			turnLabel.text = "Turn %s" % turn
			endTurnButton.visible = false
			actionContainer.visible = false
			modalPanel.visible = true
			turnPanelContainer.visible = true
			turnPanelContainer.position = slideStart
			eventLabel.text = ""
			eventLabel.visible_ratio = 0
			if Engine.is_editor_hint(): return
			var tween = create_tween()
			tween.tween_property(turnPanelContainer, "position", slideMid, slideInTime).set_ease(slideInEase).set_trans(slideInTransition)
			tween.tween_interval(slideWait)
			tween.tween_property(turnPanelContainer, "position", slideEnd, slideOutTime).set_ease(slideOutEase).set_trans(slideOutTransition)
			tween.tween_callback(func():currentPhase = TurnPhase.ACTION)
