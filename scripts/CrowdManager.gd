@tool
extends Node

var emotions = { 
	CultConstants.Emotion.FEAR: 0,
	CultConstants.Emotion.ANGER: 0,
	CultConstants.Emotion.DESPAIR: 0
}

var _nextCardMultiplierDefault = { 
	CultConstants.Emotion.FEAR: 1.0,
	CultConstants.Emotion.ANGER: 1.0,
	CultConstants.Emotion.DESPAIR: 1.0
}
	
var nextCardMultiplier = { 
	CultConstants.Emotion.FEAR: 1.0,
	CultConstants.Emotion.ANGER: 1.0,
	CultConstants.Emotion.DESPAIR: 1.0
}

@export var CrowdContainer: Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CrowdContainer = get_node("/root/Main/VBoxContainer/CrowdContainer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Play(node: CardNode):
	print("Playing card into crowd!")
	node.card.PlayCard()
	HandManager.cards.erase(node.card)
	pass
