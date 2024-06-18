@tool
class_name TurnManager extends Node

enum TurnPhase {
	START, # Start of the summoning
	ACTION,
	PLAY,
	ENTITY,
	NEXT_TURN, # End of the turn
	END, # End of the summoning (victory)
	DEFEAT,
}

@export var turn: int = 0
@export var startSpeed: float = 1
static var instance: TurnManager

@export var currentPhase: TurnPhase = TurnPhase.ENTITY:
	set(value):
		if currentPhase != TurnPhase.DEFEAT:
			currentPhase = value
			_updateStateForCurrentPhase()

@export_group("Export Assignments")
@export var modalPanel: PanelContainer
@export var actionContainer: Container
@export var gainSacrificeButton: Button
@export var dualButton: Button
@export var drawCardButton: Button
@export var endTurnButton: Button

@export_group("Event Label")
@export var eventLabel: Label
@export var textSpeed: float
@export var audioChipRate: float = 0.1
@export var eventLabelAudioPlayer: AudioStreamPlayer

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

var startedFlag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	loadLevel()
	var playLambda = func(): 
		if currentPhase != TurnPhase.ACTION: return
		currentPhase = TurnPhase.PLAY
	
	gainSacrificeButton.pressed.connect(playLambda)
	dualButton.pressed.connect(playLambda)
	drawCardButton.pressed.connect(playLambda)
	endTurnButton.pressed.connect(
		func(): 
			if currentPhase != TurnPhase.PLAY: return
			currentPhase = TurnPhase.ENTITY
	)

func loadLevel():
	turn = 0
	startedFlag = false
	currentPhase = TurnPhase.START

var audioChipRateCounter: float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !startedFlag:
		currentPhase = TurnPhase.START
	if !eventLabel: return
	if eventLabel.visible_ratio < 1.0:
		audioChipRateCounter += delta
		eventLabel.visible_ratio += textSpeed * delta
		if !eventLabel.text.is_empty() && audioChipRateCounter > audioChipRate:
			audioChipRateCounter = 0
			eventLabelAudioPlayer.play()
	else: 
		audioChipRateCounter = 0
		eventLabelAudioPlayer.stop()
	
	if !SummoningBoard.instance: return
	if (currentPhase == TurnPhase.PLAY &&
		SummoningBoard.instance.RequirementsMet()):
			currentPhase = TurnPhase.END
	if (SummoningBoard.instance.cultists.filter(
				func(agent): return agent.cultist.state == Cultist.State.ALIVE
			).size() == 0 && 
			currentPhase != TurnPhase.START &&
			currentPhase != TurnPhase.END):
		currentPhase = TurnPhase.DEFEAT

func _updateStateForCurrentPhase():
	if !endTurnButton || !actionContainer || !modalPanel || !turnPanelContainer || !eventLabel || !SummoningBoard.instance: return
	match currentPhase:
		TurnPhase.START:
			startedFlag = true
			CultMusicAudioStreamPlayer.PlayMusic(load("res://resources/sounds/music/SCP-x4x.mp3"))
			endTurnButton.visible = false
			actionContainer.visible = false
			modalPanel.visible = true
			turnPanelContainer.visible = true
			turnPanelContainer.position = slideStart
			if !SummoningBoard.instance: return
			turnLabel.text = "Ritual Binding: %s" % SummoningBoard.instance.entityAgent.entity.name
			_showSliderPanel(false, func():
				eventLabel.visible_ratio = 0
				eventLabel.text = "The ritual time has come. The summoning shall begin."
				if Engine.is_editor_hint(): return
				var timer = get_tree().create_timer(startSpeed)
				timer.timeout.connect(func():currentPhase = TurnPhase.NEXT_TURN)
			)
		TurnPhase.ACTION:
			endTurnButton.visible = false
			actionContainer.visible = true
			modalPanel.visible = true
			turnPanelContainer.visible = false
			eventLabel.visible_ratio = 0
			eventLabel.text = "Choose wisely..."
		TurnPhase.PLAY:
			endTurnButton.visible = true
			actionContainer.visible = false
			modalPanel.visible = false
			turnPanelContainer.visible = false
			eventLabel.visible_ratio = 0
			
			print(SummoningBoard.instance.summoning.uniqueName)
			if SummoningBoard.instance.summoning.uniqueName != "Level1":
				eventLabel.text = "Bind the entity in our blood!"
				return

			eventLabel.text = "Sacrifice cultists to create souls. Playing cards consume souls."
			var timer = get_tree().create_timer(6)
			timer.timeout.connect(func():
				if currentPhase != TurnPhase.PLAY: return
				eventLabel.visible_ratio = 0
				eventLabel.text = "Cards grant cultists emotions. Sacrifice emotional cultists to fulfill the ritual."
				var nextTimer = get_tree().create_timer(6)
				nextTimer.timeout.connect(func():
					if currentPhase != TurnPhase.PLAY: return
					eventLabel.visible_ratio = 0
					eventLabel.text = "If you run out of cultists, you lose."
				)
			)
		TurnPhase.ENTITY:
			endTurnButton.visible = false
			actionContainer.visible = false
			modalPanel.visible = false
			turnPanelContainer.visible = true
			turnPanelContainer.position = slideStart
			turnLabel.text = "%s Acts" % SummoningBoard.instance.entityAgent.entity.name
			_showSliderPanel(false, func():
				eventLabel.visible_ratio = 0
				eventLabel.text = SummoningBoard.instance.entityAgent._conversation(turn)
				var timer = get_tree().create_timer(2)
				timer.timeout.connect( func(): SummoningBoard.instance.entityAgent._actOnTurn(turn))
			)
		TurnPhase.NEXT_TURN:
			turn += 1
			turnLabel.text = "Turn %s" % turn
			endTurnButton.visible = false
			actionContainer.visible = false
			modalPanel.visible = true
			turnPanelContainer.visible = true
			turnPanelContainer.position = slideStart
			eventLabel.text = ""
			eventLabel.visible_ratio = 0
			#if Engine.is_editor_hint(): return
			_showSliderPanel(false, func():currentPhase = TurnPhase.ACTION)
		TurnPhase.END:
			eventLabel.visible_ratio = 0
			eventLabel.text = SummoningBoard.instance.entityAgent._bindEntity()
			var timer = get_tree().create_timer(4)
			timer.timeout.connect( func():
				eventLabel.visible_ratio = 0
				eventLabel.text = SummoningBoard.instance.entityAgent._entitySubmits()
				var submitTimer = get_tree().create_timer(4)
				submitTimer.timeout.connect( func():
					#var credits = load("res://scenes/Credits.tscn")
					turnPanelContainer.visible = true
					turnPanelContainer.position = slideStart
					turnLabel.text = "VICTORY"
					_showSliderPanel(true, func():
						var finalTimer = get_tree().create_timer(3)
						finalTimer.timeout.connect(func(): 
							if !SummoningBoard.instance.summoning.nextSummoning:
								SceneLoader.SwitchToScene(SceneLoader.CultScene.Credits)
							else:
								SceneLoader.nextSummoning = SummoningBoard.instance.summoning.nextSummoning.duplicate()
								SceneLoader.SwitchToScene(SceneLoader.CultScene.Game)
						)
					)
				)
			)
			
		TurnPhase.DEFEAT:
			endTurnButton.visible = false
			actionContainer.visible = false
			modalPanel.visible = true
			turnPanelContainer.visible = true
			eventLabel.visible_ratio = 0
			eventLabel.text = SummoningBoard.instance.entityAgent._entityVictorious()
			var timer = get_tree().create_timer(4)
			timer.timeout.connect( func():
				turnPanelContainer.visible = true
				turnPanelContainer.position = slideStart
				turnLabel.text = "DEFEAT"
				_showSliderPanel(true, func():
					var finalTimer = get_tree().create_timer(3)
					finalTimer.timeout.connect(func():
						SceneLoader.ResetScenes()
						SceneLoader.SwitchToScene(SceneLoader.CultScene.Menu)
					)
				)
			)

func _showSliderPanel(slideCompletely: bool, callable: Callable):
	var tween = create_tween()
	tween.tween_property(turnPanelContainer, "position", slideMid, slideInTime).set_ease(slideInEase).set_trans(slideInTransition)
	tween.tween_interval(slideWait)
	if slideCompletely:
		tween.tween_callback(callable)
		return
	tween.tween_property(turnPanelContainer, "position", slideEnd, slideOutTime).set_ease(slideOutEase).set_trans(slideOutTransition)
	tween.tween_callback(callable)
