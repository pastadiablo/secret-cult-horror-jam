@tool
class_name ModifyEmotionEffect extends Effect

@export var emotion: CultConstants.Emotion
@export var value: int

func GetEffectDescription(baseEmotion: CultConstants.Emotion) -> String:
	if !CrowdManager: return ""
	var multiplier = CrowdManager.nextCardMultiplier[baseEmotion]
	if multiplier == 1.0:
		return "%+d %s" % [value * multiplier,
		CultConstants.EmotionName(emotion)]
	else:
		return "[color=#%s]%+d[/color] (%d) %s" % [ 
			CultConstants.IncreaseColor.to_html() if multiplier >= 1.0 else CultConstants.DecreaseColor.to_html(),
			value * multiplier,
			value,
			CultConstants.EmotionName(emotion)]
	
func ApplyEffect(baseEmotion: CultConstants.Emotion):
	CrowdManager.emotions[emotion] += value * CrowdManager.nextCardMultiplier[baseEmotion]
