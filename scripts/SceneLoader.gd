extends Node


enum CultScene {
	Menu,
	Credits,
	Game
}

var nextSummoning: Summoning

func ResetScenes():
	SceneLoader.nextSummoning = load("res://resources/summonings/Level1.tres").duplicate()

func SwitchToScene(scene: CultScene):
	_deferredSwitch.call_deferred(scene)

func _deferredSwitch(scene: CultScene):
	get_tree().current_scene.free()
	var path = ""
	match scene:
		CultScene.Menu: path = "res://scenes/MainMenu.tscn"
		CultScene.Credits: path = "res://scenes/Credits.tscn"
		CultScene.Game: path = "res://main.tscn"
	var packed_scene: PackedScene = ResourceLoader.load(path)
	var instanced_scene = packed_scene.duplicate().instantiate()
	get_tree().root.add_child(instanced_scene)
	get_tree().current_scene = instanced_scene
