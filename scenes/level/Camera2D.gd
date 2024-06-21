extends Camera2D

var _rng = RandomNumberGenerator.new()
var _shake_strength := 0.0
var _shake_fade := 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _shake_strength > 0:
		_shake_strength = lerpf(_shake_strength, 0, _shake_fade * delta)
	
	offset = random_offset()

func apply_shake(strength, fade) -> void:
	_shake_strength = strength
	_shake_fade = fade

func random_offset() -> Vector2:
	return Vector2(_rng.randf_range(-_shake_strength, _shake_strength), _rng.randf_range(-_shake_strength, _shake_strength))
