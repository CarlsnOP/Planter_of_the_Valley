extends NinePatchRect

@onready var level_label = $LevelLabel
@onready var check_mark = $CheckMark

const GREEN_TEXTURE = preload("res://assets/green_panel.png")


var _level_number: String = "22"


# Called when the node enters the scene tree for the first time.
func _ready():
	level_label.text = _level_number


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_level_number(level_number: String) -> void:
	_level_number = level_number

func _on_gui_input(event: InputEvent):
	if event.is_action_pressed("select"):
		texture = GREEN_TEXTURE
		pass
