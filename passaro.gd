extends Area2D

@export var gravityY = 0.0004
@export var impulse = -7
var  velocity = 0.0
var screenSize
@export var audioPulo: AudioStream
@export var audioImpacto: AudioStream

func _ready() -> void:
	screenSize = get_viewport_rect().size
	Engine.max_fps = 60

func _process(delta: float) -> void:
	if Engine.time_scale == 0: return 
	Vento(delta)

	velocity = velocity + gravityY * delta
	position.y = position.y + velocity
	rotation_degrees = clamp(velocity*5, -90,90)
	if Input.is_action_just_pressed("Click"):
		velocity = impulse
		$AnimatedSprite2D.play("voo")
		$AudioStreamPlayer2D.stream = audioPulo
		$AudioStreamPlayer2D.play()
	position = position.clamp(Vector2.ZERO, screenSize)

func _on_area_entered(area: Area2D) -> void:
	Engine.time_scale = 0
	$AudioStreamPlayer2D.stream = audioImpacto
	$AudioStreamPlayer2D.play()

func resetarPosicao():
	rotation_degrees = 0
	position = get_viewport_rect().size/2
	scale.y = abs(scale.y)
	#$AnimatedSprite2D.flip_v = false
	gravityY = abs(gravityY)
	impulse = -abs(impulse)
	velocity = impulse
	ventoLigado = false


func inverter():
	impulse = -impulse
	gravityY *= -1
	velocity = 0
	scale.y = -scale.y
	#$AnimatedSprite2D.flip_v = not $AnimatedSprite2D.flip_v
	
var ventoLigado = false
var tempoVento = 0
var velocidadeVento = 0.3
var distanciaVento = 150
var direcaoVento = 1
func Vento(delta):
	if ventoLigado:
		tempoVento += delta
		position.x = screenSize.x/2 + distanciaVento*sin(tempoVento*velocidadeVento)
	if tempoVento > 10.5:
		ventoLigado = false
		
func LigarVento():
	ventoLigado = true
	tempoVento = 0
	var random_sign = sign(randf_range(-1.0, 1.0))
	distanciaVento = distanciaVento*random_sign
