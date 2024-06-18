@tool
class_name RequirementPanel extends Control

@export var board: SummoningBoard
@export var preparedContainer: Container
@export var requiredContainer: Container

var preparedMap: Dictionary = {} # {CultistAgent, TextureRect}

var soulFear = preload("res://resources/textures/counters/SoulCounter-Fear.png")
var soulAnger = preload("res://resources/textures/counters/SoulCounter-Anger.png")
var soulDespair = preload("res://resources/textures/counters/SoulCounter-Despair.png")

var entity: Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().process_frame
	if !board || !board.summoning || !board.entityAgent: return
	print("preparing requirement panel")
	entity = board.entityAgent.entity
	
	for i in entity.fearRequirement:
		requiredContainer.add_child(_createCounter(soulFear))
	for i in entity.angerRequirement:
		requiredContainer.add_child(_createCounter(soulAnger))
	for i in entity.despairRequirement:
		requiredContainer.add_child(_createCounter(soulDespair))

func _createCounter(texture: Texture2D) -> TextureRect:
	var counter = TextureRect.new()
	counter.custom_minimum_size = Vector2(32,32)
	counter.texture = texture
	return counter

func _addPrepared(agent: CultistAgent):
	var texture: Texture2D
	match agent.cultist.emotion:
		CultConstants.Emotion.FEAR:
			texture = soulFear
		CultConstants.Emotion.ANGER:
			texture = soulAnger
		CultConstants.Emotion.DESPAIR:
			texture = soulDespair
	
	var prepared = _createCounter(texture)
	preparedMap[agent] = prepared
	preparedContainer.add_child(prepared)

func _removePrepared(agent: CultistAgent):
	preparedContainer.remove_child(preparedMap[agent])
	preparedMap.erase(agent)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !board || !board.summoning || !entity: return

	for agent in board.summoning.souls:
		if (!is_instance_valid(agent) || 
			agent.cultist.emotion == CultConstants.Emotion.NONE ||
			preparedMap.has(agent)): continue
		_addPrepared(agent)
	
	var removals := []
	for key in preparedMap.keys():
		if is_instance_valid(key) && board.summoning.souls.has(key): continue
		removals.append(key)
		
	for removal in removals:
		_removePrepared(removal)
