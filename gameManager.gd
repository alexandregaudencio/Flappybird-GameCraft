extends Node2D

@export var gameoverControl: Control
@export var inicioControl: Control

@export var highscoreLabel: Label
var highscore = 0

@export var fundo: Sprite2D
@export var fundoDia: Texture
@export var fundoNoite: Texture

enum GameState {
	START, 
	GAMEPLAY,
	GAMEOVER
}
var state: GameState
signal  stateChange(newState)

func _ready() -> void:
	SetState(GameState.START)

var pontuacaoAtual = 0

func _process(delta: float) -> void:

	var inputPressionado = 	Input.is_action_just_pressed("Click")
	var estaNoInicio = state == GameState.START
	if estaNoInicio && inputPressionado:
		SetState(GameState.GAMEPLAY)
	if Engine.time_scale == 0: return
	Acelerar()
	
func SetState(newState):
	state = newState
	emit_signal("stateChange",state)


func _on_state_change(newState: Variant) -> void:
	match newState:
		0:
			fundo.texture = fundoDia
			LoadHighscore()
			Engine.time_scale = 0
			gameoverControl.visible = false
			inicioControl.visible = true
			$Passaro.resetarPosicao()
			$GeradorCano.ResetarCanos()
		1:
			Engine.time_scale = 1
			inicioControl.visible = false
		2:
			SaveHighscore()
			Engine.time_scale = 0
			gameoverControl.visible = true


func _on_passaro_area_entered(area: Area2D) -> void:
	SetState(GameState.GAMEOVER)


func _on_button_button_up() -> void:
		SetState(GameState.START)

func LoadHighscore():
	if SaveData.HasKey("highscore"):
		highscore = SaveData.GetKey("highscore")
		highscoreLabel.text = str(highscore)

func SaveHighscore():
	var canos = $GeradorCano.canos
	if canos > highscore:
		highscore = canos
		SaveData.SetKey("highscore",highscore)

	

func _on_gerador_cano_cano_gerado(canos: Variant) -> void:
	pontuacaoAtual = canos
	TentarEscurecer(canos)
	TentarInverterGravidade(canos)
	TentarLigarVento(canos)

func Acelerar():
	if pontuacaoAtual < 15 || Engine.time_scale > 5: return
	if state == 1:
		Engine.time_scale += 0.0005

var trocarDia = 12
var intervaloEscurecimento= 3
func TentarEscurecer(canos):
	var éDia = fundo.texture == fundoDia
	if canos < trocarDia: return
	if canos % trocarDia == 0:
		if fundo.texture == fundoDia:
			fundo.texture = fundoNoite
		else:
			fundo.texture = fundoDia
		
	if éDia == false && canos % intervaloEscurecimento == 0 :
		$AnimationPlayer.play("escurecer")



var  canosInversao = 28
var canosSemInversao = 10
func TentarInverterGravidade(canos):
	if canos < canosInversao: return
	var inverter = canos % canosInversao == 0
	var desinverter = (canos -canosSemInversao) % canosInversao == 0
	if inverter || desinverter:
		$Passaro.inverter()
		$GeradorCano.limparCanos()
		$SFXGravidade.play()
		
func TentarLigarVento(canos):
	if canos != 0 && canos % 22 ==0:
		$Passaro.LigarVento()
		$SFXVento.play()
