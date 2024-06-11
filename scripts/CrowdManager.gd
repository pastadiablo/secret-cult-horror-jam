@tool
class_name CrowdManager extends Node

static var emotions = { 
	CultConstants.Emotion.FEAR: 0,
	CultConstants.Emotion.ANGER: 0,
	CultConstants.Emotion.DESPAIR: 0
}

static var _nextCardMultiplierDefault = { 
	CultConstants.Emotion.FEAR: 1.0,
	CultConstants.Emotion.ANGER: 1.0,
	CultConstants.Emotion.DESPAIR: 1.0
}
	
static var nextCardMultiplier = { 
	CultConstants.Emotion.FEAR: 1.0,
	CultConstants.Emotion.ANGER: 1.0,
	CultConstants.Emotion.DESPAIR: 1.0
}

@export var _crowdContainer: Container

static var Instance : CrowdManager
static var CrowdContainer: Container:
	get: return Instance._crowdContainer

static func Play(node: CardNode):
	Instance._Play(node)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Instance = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _Play(node: CardNode):
	print("Playing card into crowd!")
	node.card.PlayCard()
	HandManager.cards.erase(node.card)
	pass
