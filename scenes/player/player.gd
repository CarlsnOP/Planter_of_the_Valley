#extends AnimatedSprite2D
#
#@onready var movement = $Movement
#@onready var tween = get_tree().create_tween()
#
#func _ready():
	#SignalManager.move_down.connect(move_down)
	#
#func move_down(pos: Vector2) -> void:
	#var new_pos = pos
	#tween.tween_property(self, "position", Vector2(new_pos.x, new_pos.y), 1)
