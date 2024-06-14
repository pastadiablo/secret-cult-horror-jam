@tool
class_name ModifyEmotionEffect extends Effect

@export var cultistCount: int = 1

func GetEffectDescription(cardEmotion: CultConstants.Emotion) -> String:
	return "[center]%sx[img=32]res://resources/textures/counters/CultistCounter-None.png[/img]->[img=32]res://resources/textures/counters/CultistCounter-%s.png[/img][/center]" % [
		cultistCount, 
		CultConstants.EmotionName(cardEmotion)
	]
	
func ApplyEffect(cardEmotion: CultConstants.Emotion, cultist: Cultist):
	print("applying emotion")
	cultist.emotion = cardEmotion
	
func ValidForCultist(cultist: Cultist) -> bool:
	return cultist.state == Cultist.State.ALIVE
