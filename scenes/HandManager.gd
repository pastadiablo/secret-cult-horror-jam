@tool
extends Node

@export var cards : Array[Card] = []
@export var hand_size: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var button: Button = get_node("/root/Main/VBoxContainer/CardBlock/MarginContainer/DealButton")
	button.pressed.connect(DealHand)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func DealHand() -> void:
	cards.clear()
	var random = RandomNumberGenerator.new()
	for i in hand_size:
		cards.append(CardCatalogue.cards[random.randi_range(0, CardCatalogue.cards.size()-1)].duplicate(true))
