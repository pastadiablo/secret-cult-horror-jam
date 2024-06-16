class_name DialogueQueue extends Node

@export var dialogueLabel: Label

var instance: DialogueQueue



func _ready() -> void:
	instance = self

func _process(delta: float) -> void:
	pass

# speed is in seconds
func InsertToQueue(dialogue: String, speed: float):
	pass
