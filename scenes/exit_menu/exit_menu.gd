extends CanvasLayer


func _on_button_pressed():
	visible = false
	SignalManager.paused.emit()

func _on_button_2_pressed():
	SignalManager.paused.emit()
	GameManager.load_main_scene()
