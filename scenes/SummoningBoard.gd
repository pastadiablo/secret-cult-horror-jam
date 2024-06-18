@tool
class_name SummoningBoard extends Node2D

@export var summoning: Summoning
@export var circlesCenter: Vector2
@export var soulLabel: Label
@export var cultistLabel: Label
@export var sacrificeLabel: Label
@export var sacrificeButton: Button
@export var dualButton: Button
@export var entityNameLabel: Label

var entityAgent: EntityAgent
var hoveredCultist: CultistAgent
var cultists: Array[CultistAgent]:
	get:
		var children: Array[CultistAgent] = []
		children.assign(get_children().filter(func(child): return child is CultistAgent))
		return children
var livingCultists: Array[CultistAgent]:
	get:
		var children: Array[CultistAgent] = []
		children.assign(get_children().filter(func(child): 
			return child is CultistAgent && child.cultist.state == Cultist.State.ALIVE))
		return children

static var instance: SummoningBoard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	for child in get_children():
		child.queue_free()
		
	if !summoning: 
		if Engine.is_editor_hint(): return
		else: 
			summoning = SceneLoader.nextSummoning.duplicate()
	
	entityAgent = EntityAgent.Create(summoning.entityPath)
	entityAgent.scale = Vector2(summoning.zoom, summoning.zoom)
	add_child(entityAgent)
	entityAgent.owner = self
	
	for circle in summoning.circles:
		_constructCircle(circle)
	
	print(summoning.circles.size())
	entityNameLabel.text = entityAgent.entity.name
	if !sacrificeButton: return
	sacrificeButton.pressed.connect(func(): summoning.sacrifices += 2)
	dualButton.pressed.connect(func(): summoning.sacrifices += 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !soulLabel: return
	if !summoning: return
	soulLabel.text = "x %s" % summoning.souls.size()
	
	_clearInvalidSouls(summoning.souls)
	
	if !sacrificeLabel: return
	sacrificeLabel.text = "x %s" % summoning.sacrifices
	
	if !cultistLabel: return
	var count = 0
	for child in get_children():
		if child is CultistAgent && child.cultist.state == Cultist.State.ALIVE:
			count += 1
	cultistLabel.text = "x %s" % count

func _clearInvalidSouls(souls: Array[CultistAgent]):
	var invalidSouls := []
	for soul in souls:
		if (!is_instance_valid(soul) ||
			soul == null ||
			soul.cultist.state != Cultist.State.SACRIFICED):
			invalidSouls.append(soul)
	for soul in invalidSouls:
		if (is_instance_valid(soul)):
			souls.erase(soul)
		else:
			pass

func _constructCircle(circle: Circle):
	var circleSprite = Sprite2D.new()
	circleSprite.texture = circle.texture
	circleSprite.scale = Vector2(1.0 * summoning.zoom, 0.5 * summoning.zoom)
	circleSprite.position = Vector2(circlesCenter.x, circlesCenter.y )
	circleSprite.z_index = -1	
	add_child(circleSprite)
	circleSprite.owner = self
	
	var n = circle.cultistCount
	var r = summoning.zoom * circle.texture.get_width() / 2
	var tilt = deg_to_rad(circle.tiltDegree)
	for i in n:
		var cultist = Cultist.new()
		var child = CultistAgent.Create(cultist)
		child.playerTurn = true
		child.Sacrificed.connect(CultistSacrificed)
		child.Consumed.connect(SoulConsumed)
		child.EnteringCultist.connect(MouseEnteredCultist)
		child.ExitingCultist.connect(MouseExitedCultist)
		child.scale = Vector2(summoning.zoom, summoning.zoom)
		var angle = 2 * PI * i / n + deg_to_rad(circle.cultistOffset)
		var childPosition = Vector3(circlesCenter.x + r * cos(angle), circlesCenter.y + r * sin(angle), log(pow(r,2+summoning.zoom))).rotated(Vector3(1.0, 0.0, 0.0), tilt)
		child.position =  Vector2(snapped(childPosition.x, 1.0), snapped(childPosition.y, 1.0))
		add_child(child)
		child.owner = self

func CanSacrifice(cultist: CultistAgent)->bool:
	return TurnManager.instance.currentPhase == TurnManager.instance.TurnPhase.PLAY && summoning.sacrifices > 0

func RequirementsMet() -> bool:
	return (entityAgent.entity.fearRequirement <= summoning.souls.filter(func(soul): return soul.cultist.emotion == CultConstants.Emotion.FEAR).size() &&
	entityAgent.entity.angerRequirement <= summoning.souls.filter(func(soul): return soul.cultist.emotion == CultConstants.Emotion.ANGER).size() &&
	entityAgent.entity.despairRequirement <= summoning.souls.filter(func(soul): return soul.cultist.emotion == CultConstants.Emotion.DESPAIR).size())
	
func CultistSacrificed(agent: CultistAgent):
	summoning.souls.append(agent)
	

func SoulsToConsume(souls: int) -> Array[CultistAgent]:
	var soulBuckets = [ summoning.souls.filter(func(soul): return soul.cultist.emotion == CultConstants.Emotion.FEAR), 
						summoning.souls.filter(func(soul): return soul.cultist.emotion == CultConstants.Emotion.ANGER),
						summoning.souls.filter(func(soul): return soul.cultist.emotion == CultConstants.Emotion.DESPAIR)]
	
	soulBuckets.sort_custom(func(a, b):a.size() < b.size())
	soulBuckets.insert(0, summoning.souls.filter(func(soul): return soul.cultist.emotion == CultConstants.Emotion.NONE))
	var orderedSouls: Array[CultistAgent] = []
	for bucket in soulBuckets:
		for soul in bucket:
			orderedSouls.append(soul)
	if orderedSouls.size() < souls:
		push_error("Somehow decided to consume more souls than available!")
		return []
	
	return orderedSouls.slice(0, souls)
	
func ConsumeSouls(souls: int) -> void:
	var orderedSouls = SoulsToConsume(souls)
	for soul in orderedSouls:
		soul.ConsumeSoul()

	#var sacrificed: Array[CultistAgent] = []
	#for cultist in get_children():
		#if cultist is not CultistAgent: continue
		#var agent: CultistAgent = cultist
		#if agent.cultist.state == Cultist.State.SACRIFICED:
			#sacrificed.append(agent)	
	#if sacrificed.size() < souls: 
		#push_error("Consumed more souls than we had! WHAT?!?")
	#for i in souls:
		#sacrificed[i].ConsumeSoul()
	
func SoulConsumed(agent: CultistAgent):
	print("Consuming soul!")
	summoning.souls.erase(agent)
	
func MouseEnteredCultist(agent: CultistAgent):
	hoveredCultist = agent
	if agent.cultist.state != Cultist.State.ALIVE: return
	if HandManager.instance.draggingCard == null: return
	print("Highlighting souls")
	var cost = HandManager.instance.draggingCard.card.cost
	var souls = SoulsToConsume(cost)
	for soul in souls:
		soul.HighlightSoulForConsumption()
	
func MouseExitedCultist(agent: CultistAgent):
	if hoveredCultist == agent:
		hoveredCultist = null
	if HandManager.instance.draggingCard == null: return
	print("Clearing soul highlight")
	var cost = HandManager.instance.draggingCard.card.cost
	var souls = SoulsToConsume(cost)
	for soul in souls:
		soul.RemoveSoulHighlight()

func GetCultistAtMousePosition() -> CultistAgent:
	for cultist in get_children():
		if cultist is not CultistAgent: continue
		var agent: CultistAgent = cultist
		if agent.sprite.get_rect().has_point(agent.sprite.get_local_mouse_position()):
			return agent
	return null
		
