@tool
class_name HandManager extends Node

@export var _cards : Array[Card] = []
@export var hand_size: int = 3
@export var dealButton: Button


static var _instance: HandManager = self

static var cards: Array[Card]:
	get:
		if _instance:
			return _instance._cards
		return []
	set(value): 
		if _instance: 
			_instance._cards = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_instance = self
	dealButton.pressed.connect(DealHand)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func DealHand() -> void:
	_cards.clear()
	var random = RandomNumberGenerator.new()
	for i in hand_size:
		_cards.append(CardCatalogue.cards[random.randi_range(0, CardCatalogue.cards.size()-1)].duplicate(true))
