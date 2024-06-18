class_name MainMenu extends PanelContainer

@export var playButton: Button
@export var creditsButton: Button
@export var quitButton: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneLoader.ResetScenes()
	playButton.pressed.connect(func():SceneLoader.SwitchToScene(SceneLoader.CultScene.Game))
	creditsButton.pressed.connect(func():SceneLoader.SwitchToScene(SceneLoader.CultScene.Credits))
	quitButton.pressed.connect(func(): get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST))
