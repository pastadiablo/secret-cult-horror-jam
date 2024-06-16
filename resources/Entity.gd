@tool
class_name Entity extends Resource

@export var texture: Texture2D
@export var fearRequirement: int
@export var angerRequirement: int
@export var despairRequirement: int

func requirement(emotion: CultConstants.Emotion) -> int:
	match emotion:
		CultConstants.Emotion.FEAR: return fearRequirement
		CultConstants.Emotion.ANGER: return angerRequirement
		CultConstants.Emotion.DESPAIR: return despairRequirement
	return 0
