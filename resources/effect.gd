@tool
class_name Effect extends Resource

func GetEffectDescription(baseEmotion: CultConstants.Emotion) -> String:
	return "Base Effect"
	
func ApplyEffect(baseEmotion: CultConstants.Emotion):
	push_error("Effect Not Implemented!")
