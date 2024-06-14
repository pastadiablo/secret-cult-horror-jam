@tool
class_name Effect extends Resource

func GetEffectDescription(cardEmotion: CultConstants.Emotion) -> String:
	return "Base Effect"
	
func ApplyEffect(cardEmotion: CultConstants.Emotion, cultist: Cultist):
	push_error("Effect Not Implemented!")

func ValidForCultist(cultist: Cultist) -> bool:
	push_error("Effect Not Implemented!")
	return false
