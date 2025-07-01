extends Node2D

@export var cano: PackedScene
@export var canoEspecial: PackedScene
@export var tempoCriacao = 2
var tempoDecorrido = 0
var canos:int = -1
@export var textoCanos: Label

signal CanoGerado(canos)

func _process(delta: float) -> void:
	tempoDecorrido = tempoDecorrido + delta
	if tempoDecorrido > tempoCriacao:
		tempoDecorrido = 0
		criarCano()
	
func criarCano():
	var canoCriado = cano.instantiate()
	var rand: int = randf_range(2,5)
	if canos > 5 && canos % rand == 0:
		canoCriado = canoEspecial.instantiate()
		
	add_child(canoCriado)
	canos += 1
	textoCanos.text = str(canos)
	emit_signal("CanoGerado",canos)

func ResetarCanos():
	canos = 0	
	emit_signal("CanoGerado",canos)
	textoCanos.text = "0"
	limparCanos()

func limparCanos():
	for filho in get_children():
		filho.queue_free()

	
