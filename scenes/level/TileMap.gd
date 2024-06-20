extends TileMap

const LIGHT_ON = preload("res://scenes/light_on/light_on.tscn")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_light(array) -> void:
	var pos
	for i in range(0, array.size() - 1):
		pos = map_to_local(array[i])
		var x = pos.x
		var y = pos.y
		var f = LIGHT_ON.instantiate()
		f.position(Vector2(x,y))
