extends CPUParticles2D

@onready var timer = $Timer

var _lifeline := 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(lifetime + _lifeline)
	emitting = true



func _on_timer_timeout():
	queue_free()
