@tool
class_name Entity extends Resource

@export var texture: Texture2D
@export var requirements: Dictionary = {
	CultConstants.Emotion.ANGER: 0,
	CultConstants.Emotion.FEAR: 0,
	CultConstants.Emotion.DESPAIR: 0
}
