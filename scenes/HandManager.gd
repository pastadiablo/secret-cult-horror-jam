@tool
class_name HandManager extends Node

@export var _cards : Array[Card] = []
@export var hand_size: int = 3
@export var dealButton: Button


static var instance: HandManager = self

static var cards: Array[Card]:
	get:
		if instance:
			return instance._cards
		return []
	set(value): 
		if instance: 
			instance._cards = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	dealButton.pressed.connect(DrawCard)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func DrawCard() -> void:
	var random = RandomNumberGenerator.new()
	_cards.append(CardCatalogue.cards[random.randi_range(0, CardCatalogue.cards.size()-1)].duplicate(true))
