@tool
class_name SummoningBoard extends Node2D

@export var summoning: Summoning
var node_map: Dictionary = {} #{Cultist, CultistAgent}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !summoning: 
		if Engine.is_editor_hint(): return
		else: summoning = load("res://resources/summonings/Level1.tres")
	for cultist in summoning.cultists:
		var child = CultistAgent.Create(cultist)
		add_child(child)
		child.owner = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !summoning: return
	for cultist in summoning.cultists:
		if cultist && get_children().all(func(child): 
			return child is CultistAgent && is_instance_valid(child) && child.cultist != cultist):
			var child = CultistAgent.Create(cultist)
			add_child(child)
			child.owner = self
	
	for child in get_children():
		if Engine.is_editor_hint():
			if child is CultistAgent && is_instance_valid(child):
				child.cultist.position = child.position
		if child is CultistAgent && is_instance_valid(child):
			if !summoning.cultists.has(child.cultist):
				child.queue_free()
