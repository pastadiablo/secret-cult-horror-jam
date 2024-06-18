@tool
class_name Entity extends Resource

@export var name: String
@export var fearRequirement: int
@export var angerRequirement: int
@export var despairRequirement: int

@export_group("Conversation")
@export var greeting: String
@export var converse: Array[String]
@export var plead: String
@export var submit: String
@export var victory: String

@export_group("Sounds")
@export var bgmusic: AudioStream

func requirement(emotion: CultConstants.Emotion) -> int:
	match emotion:
		CultConstants.Emotion.FEAR: return fearRequirement
		CultConstants.Emotion.ANGER: return angerRequirement
		CultConstants.Emotion.DESPAIR: return despairRequirement
	return 0
