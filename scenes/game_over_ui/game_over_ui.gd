extends Control

@onready var record_label = $MC/NP/MC/VB/RecordLabel
@onready var moves_label = $MC/NP/MC/VB/MovesLabel
@onready var main_menu = $MC/NP/MC/VB/HBoxContainer/MainMenu
@onready var retry = $MC/NP/MC/VB/HBoxContainer/Retry
@onready var next_level = $MC/NP/MC/VB/HBoxContainer/NextLevel

var _hover_scale: float = 1.2
var _offset: Vector2 = Vector2(100, 37.5)

func _ready():
	set_the_offset()

func new_game() -> void:
	hide()
	record_label.hide()

func set_the_offset() -> void:
	next_level.pivot_offset.x = _offset.x
	next_level.pivot_offset.y = _offset.y
	
	main_menu.pivot_offset.x = _offset.x
	main_menu.pivot_offset.y = _offset.y
	
	retry.pivot_offset.x = _offset.x
	retry.pivot_offset.y = _offset.y

func game_over(level: String, moves: int) -> void:
	show()
	moves_label.text = str(moves) + " moves made"
	if ScoreSync.score_is_new_best(level, moves):
		record_label.show()

#buttons
func _on_main_menu_pressed():
	GameManager.load_main_scene()

func _on_main_menu_mouse_entered():
	main_menu.scale = main_menu.scale * _hover_scale

func _on_main_menu_mouse_exited():
	main_menu.scale = main_menu.scale / _hover_scale

func _on_retry_pressed():
	SignalManager.restart.emit()

func _on_retry_mouse_entered():
	retry.scale = retry.scale * _hover_scale

func _on_retry_mouse_exited():
	retry.scale = retry.scale / _hover_scale

func _on_next_level_pressed() -> void:
	SignalManager.next_level.emit()

func _on_next_level_mouse_entered():
	next_level.scale = next_level.scale * _hover_scale

func _on_next_level_mouse_exited():
	next_level.scale = next_level.scale / _hover_scale
