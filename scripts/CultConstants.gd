@tool
class_name CultConstants
enum Emotion { NONE, FEAR, ANGER, DESPAIR}

static var EmotionColors = { 
	Emotion.FEAR: Color("#433a59"),
	Emotion.ANGER: Color("#5d2929"),
	Emotion.DESPAIR: Color("#353f54"),
}

static var EmotionColorsLight = { 
	Emotion.FEAR: Color("#9e90a7"),
	Emotion.ANGER: Color("#9d8487"),
	Emotion.DESPAIR: Color("#8f8da2"),
}

static var IncreaseColor = Color("#ffffff")
static var DecreaseColor = Color("#b83636")

static func EmotionName(emotion: Emotion) -> String:
	var emotionName = ""
	match emotion:
		Emotion.NONE: emotionName = "None"
		Emotion.FEAR: emotionName = "Fear"
		Emotion.ANGER: emotionName = "Anger"
		Emotion.DESPAIR: emotionName = "Despair"
	return emotionName
