extends Control

@onready var record_label = $MC/NP/MC/VB/RecordLabel

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game() -> void:
	hide()
	record_label.hide()

func game_over(level: String, moves: int) -> void:
	show()
	if ScoreSync.score_is_new_best(level, moves):
		record_label.show()
