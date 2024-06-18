@tool
class_name Summoning extends Resource

@export var uniqueName: String
@export var circles: Array[Circle] = []
@export var entityPath: String = ""
@export var sacrifices: int = 0
@export var zoom: int = 1
@export var nextSummoning: Summoning

var souls: Array[CultistAgent] = []
