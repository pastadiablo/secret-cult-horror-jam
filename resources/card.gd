@tool
class_name Card extends Resource

@export var name: String
@export var depiction: Texture2D
@export var emotion: CultConstants.Emotion
@export var effects: Array[Effect] = []
@export var cost: int = 1

func CardCanBePlayed(cultist: Cultist) -> bool:
	if !effects: return false
	var withinCost = SummoningBoard.instance.summoning.souls.size() >= cost
	var effectsValid = effects.any(func(effect: Effect): return effect.ValidForCultist(cultist))
	return withinCost && effectsValid

func PlayCard(cultist: Cultist):
	if !effects: return
	for effect in effects:
		if !effect: continue
		effect.ApplyEffect(emotion, cultist)
	SummoningBoard.instance.ConsumeSouls(cost)
