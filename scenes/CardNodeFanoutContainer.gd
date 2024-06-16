@tool
@icon("res://resources/textures/icons/CardFanoutContainerIcon.png")
class_name CardNodeFanoutContainer extends Container

@export var maxCardAngle = 10:
	set(value):
		maxCardAngle = value
		_adjustSize()
@export var yOffset = 10:
	set(value):
		yOffset = value
		_adjustSize()
@export var horizontalMargin = 10:
	set(value):
		horizontalMargin = value
		_adjustSize()

var node_map: Dictionary = {} #{Card, CardNode}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node_map.clear()
	for child in get_children():
		child.queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cards = node_map.keys()
	var tracked = []
	if HandManager.instance:
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
	
func _addCardNode(card: Card):
	var node = CardNode.create(card)
	node_map[card] = node
	node.tree_entered.connect(_adjustSize)
	node.tree_exited.connect(_adjustSize)
	add_child(node)
	node.owner = self
	await get_tree().process_frame
	_adjustSize()
	node.targetPosition = node.global_position

func _nodeRefresh(node: CardNode):
	_adjustSize()

func _adjustSize():
	print("Adjusting Size")
	#add_theme_constant_override("separation", (baseSpread + (node_map.keys().size() * spreadFactor)))
	var i = 0
	var count = get_children().size()
	if count < 1: return
	if count < 4:
		i = 1
		count = 5
	var childSize = get_children()[0].size.x
	var children = get_children()
	for child in get_children(): # We only operate on equally-sized controls in a fanout container
		if snapped(child.size.x, 1.0) != snapped(childSize, 1.0):
			children.remove_at(children.find(child))
	var width = size.x - horizontalMargin * 2
	var childDistance = ((width - childSize) / (count - 1)) - childSize
	var radius = width / (2 * sin(deg_to_rad(maxCardAngle * 2)/2))
	for child in children:
		if child is CardNode:
			var interp = ((float)(i)) / (count-1)			
			child.rotationZ = lerp(-maxCardAngle, maxCardAngle, interp)			
			child.position.x = i * (childSize + childDistance) + horizontalMargin
			child.position.y = position.y + radius + radius * sin(deg_to_rad(child.rotationZ-90)) + yOffset
			child.targetPosition = child.global_position
			i += 1
				
	
