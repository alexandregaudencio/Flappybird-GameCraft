extends Area2D
@export var velocidade: float = 3
@export var yExtra = 150

func _ready() -> void:
	var screenSize = get_viewport_rect().size
	position.x = screenSize.x + 50
	var yExtra = randf_range(-yExtra,yExtra)
	position.y = screenSize.y/2 -50 + yExtra

func _process(delta: float) -> void:
	if Engine.time_scale == 0: return
	position.x = position.x - velocidade*delta
	
	if position.x < -100:
		queue_free()
