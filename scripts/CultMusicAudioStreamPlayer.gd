extends AudioStreamPlayer

func _ready():
	volume_db = -20
	
func PlayMusic(newStream: AudioStream):
	stream = newStream
	pitch_scale = 0.5
	play()
