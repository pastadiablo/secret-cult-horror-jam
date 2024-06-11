@tool
class_name AmplifyNextEmotionEffect extends Effect

@export var emotion: CultConstants.Emotion
@export var value: float

func GetEffectDescription(baseEmotion: CultConstants.Emotion) -> String:
	var baseValue = value * 100
	var multiplier = CrowdManager.nextCardMultiplier[baseEmotion]
	if multiplier == 1.0:
		return "Next %s is %d%% effective" % [CultConstants.EmotionName(emotion), 
			snapped(baseValue, 1.0)]
	else:
		return "Next %s is [color=#%s]%d%%[/color] (%d%%) effective" % [CultConstants.EmotionName(emotion), 
			CultConstants.IncreaseColor.to_html() if multiplier >= 1.0 else CultConstants.DecreaseColor.to_html(),
			snapped(baseValue * multiplier, 1.0),
			snapped(multiplier * 100, 1.0)]
	
func ApplyEffect(baseEmotion: CultConstants.Emotion):
	CrowdManager.nextCardMultiplier[emotion] = value * CrowdManager.nextCardMultiplier[baseEmotion]
