@tool
class_name SummoningBoard extends Node2D

@export var summoning: Summoning
@export var circlesCenter: Vector2
@export var soulLabel: Label
@export var sacrificeLabel: Label

var node_map: Dictionary = {} #{Cultist, CultistAgent}

var hoveredCultist: CultistAgent

static var instance: SummoningBoard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	for child in get_children():
		child.queue_free()
		
	if !summoning: 
		if Engine.is_editor_hint(): return
		else: summoning = load("res://resources/summonings/Level1.tres")
	for circle in summoning.circles:
		_constructCircle(circle)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !soulLabel: return
	soulLabel.text = "x %s" % summoning.souls
	
	if !sacrificeLabel: return
	sacrificeLabel.text = "x %s" % summoning.sacrifices

func _constructCircle(circle: Circle):
	var circleSprite = Sprite2D.new()
	circleSprite.texture = circle.texture
	circleSprite.scale.y = 0.5
	circleSprite.position = Vector2(circlesCenter.x, circlesCenter.y )
	circleSprite.z_index = -1
	
	add_child(circleSprite)
	circleSprite.owner = self
	
	var n = circle.cultistCount
	var r = circle.texture.get_width() / 2
	var tilt = deg_to_rad(circle.tiltDegree)
	for i in n:
		var cultist = Cultist.new()
		var child = CultistAgent.Create(cultist)
		child.playerTurn = true
		child.Sacrificed.connect(CultistSacrificed)
		child.Consumed.connect(SoulConsumed)
		child.EnteringCultist.connect(MouseEnteredCultist)
		child.ExitingCultist.connect(MouseExitedCultist)
		var angle = 2 * PI * i / n + deg_to_rad(circle.cultistOffset)
		var childPosition = Vector3(circlesCenter.x + r * cos(angle), circlesCenter.y + r * sin(angle), log(pow(r,5))).rotated(Vector3(1.0, 0.0, 0.0), tilt)
		child.position =  Vector2(childPosition.x, childPosition.y)
		add_child(child)
		child.owner = self

func CultistSacrificed(agent: CultistAgent):
	summoning.souls += agent.cultist.souls
	pass

func ConsumeSouls(souls: int) -> void:
	summoning.souls -= souls
	var sacrificed: Array[CultistAgent] = []
	for cultist in get_children():
		if cultist is not CultistAgent: continue
		var agent: CultistAgent = cultist
		if agent.cultist.state == Cultist.State.SACRIFICED:
			sacrificed.append(agent)	
	if sacrificed.size() < souls: 
		push_error("Consumed more souls than we had! WHAT?!?")
	for i in souls:
		sacrificed[i].ConsumeSoul()
	
func SoulConsumed(agent: CultistAgent):
	pass
	
func MouseEnteredCultist(agent: CultistAgent):
	hoveredCultist = agent
	
func MouseExitedCultist(agent: CultistAgent):
	if hoveredCultist == agent:
		hoveredCultist = null

func GetCultistAtMousePosition() -> CultistAgent:
	for cultist in get_children():
		if cultist is not CultistAgent: continue
		var agent: CultistAgent = cultist
		if agent.sprite.get_rect().has_point(agent.sprite.get_local_mouse_position()):
			return agent
	return null
		
