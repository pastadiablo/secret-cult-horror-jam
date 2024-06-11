@tool
class_name CardNodeFanoutContainer extends Control

var node_map: Dictionary = {} #{Card, CardNode}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var cards = node_map.keys()
	var tracked = []
	if HandManager._instance:
		tracked = HandManager.cards
	
	for card in cards:
		if (!tracked.has(card)):
			_removeCardNode(card)
	for card in tracked:
		if (!cards.has(card)):
			_addCardNode(card)

func _removeCardNode(card: Card):
	for child in get_children():
		if child is CardNode && child.card == card:
			node_map.erase(card)
			child.queue_free()
			break
	pass
	
func _addCardNode(card: Card):
	var node = CardNode.create(card)
	node_map[card] = node
	add_child(node)
	await get_tree().process_frame
	node.targetPosition = node.global_position
	pass
