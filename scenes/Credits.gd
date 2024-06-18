extends PanelContainer

@export var returnButton: Button
@export var credits: RichTextLabel
@export var scroll: ScrollContainer
@export var scrollSpeed: float = 1

var _stopScroll = false

func _ready() -> void:
	returnButton.pressed.connect(func():SceneLoader.SwitchToScene(SceneLoader.CultScene.Menu))
	credits.meta_clicked.connect(func(meta): OS.shell_open(meta))

func _process(delta: float) -> void:
	if !_stopScroll:
		scroll.scroll_vertical += delta * scrollSpeed
	
func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		_stopScroll = true
