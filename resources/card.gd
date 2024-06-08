@tool
class_name Card extends Resource

@export var name: String
@export var depiction: Texture2D
@export var emotion: CultConstants.Emotion
@export var effects: Array[Effect]

func PlayCard():
	if !effects: return
	for effect in effects:
		if !effect: continue
		effect.ApplyEffect()
