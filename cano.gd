extends Area2D
@export var velocidade: float = 3
@export var yExtra = 150
@export var especial = false
var velocidadeEmY = 100.0
var amplitude = 100
var origin
func _ready() -> void:
	var screenSize = get_viewport_rect().size
	position.x = screenSize.x + 50
	var yExtra = randf_range(-yExtra,yExtra)
	position.y = screenSize.y/2 -50 + yExtra
	origin = position
	
func _process(delta: float) -> void:
	if Engine.time_scale == 0: return
	position.x = position.x - velocidade*delta
	if(especial):
		position.y = origin.y-50 + sin(position.x/velocidadeEmY)*amplitude
	if position.x < -100:
		queue_free()
