extends Node

const LEVEL_SCENE: PackedScene = preload("res://scenes/level/level.tscn")
const MAIN_SCENE: PackedScene = preload("res://scenes/main/main.tscn")


var _level_selected: String

func _ready():
	SignalManager.on_level_selected.connect(on_level_selected)
	SignalManager.restart.connect(restart)
	SignalManager.next_level.connect(next_level)

func get_level_selected() -> String:
	return _level_selected

func on_level_selected(ln: String) -> void:
	_level_selected = ln
	get_tree().change_scene_to_packed(LEVEL_SCENE)
	
func load_main_scene() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)

func restart() -> void:
	get_tree().change_scene_to_packed(LEVEL_SCENE)

func next_level() -> void:
	_level_selected = str(_level_selected.to_int() + 1)
	get_tree().change_scene_to_packed(LEVEL_SCENE)
