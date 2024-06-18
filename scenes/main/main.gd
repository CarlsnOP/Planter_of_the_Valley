extends CanvasLayer

@onready var grid_container = $MC/VB/GridContainer

const BUTTON_SCENE: PackedScene = preload("res://scenes/levelbutton/level_button.tscn")
const LEVEL_COLS: int = 6
const LEVEL_ROWS: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_grid()


func setup_grid() -> void:
	for level in range(LEVEL_COLS*LEVEL_ROWS):
		var lbs = BUTTON_SCENE.instantiate()
		lbs.set_level_number(str(level + 1))
		grid_container.add_child(lbs)
