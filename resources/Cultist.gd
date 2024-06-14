@tool
class_name Cultist extends Resource

enum State {
	ALIVE,
	DEAD,
	SACRIFICED
}

@export var emotion: CultConstants.Emotion = CultConstants.Emotion.NONE
@export var state: State = State.ALIVE
@export var souls: int = 1
