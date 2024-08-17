extends Node2D
class_name Sword

#sinais
signal updateCooldown(amount: int)

#variaveis onready
@onready var player = get_tree().get_first_node_in_group("player")
@onready var attackAnim = $attackAnim
@onready var sprite = $sprite
@onready var chargeAudio = $chargeAudio
@onready var attackAudio = $attackAudio
@onready var cooldownUI = $hudLayer/cooldownUI
@onready var chargedAttackAudio = $chargedAttackAudio
@onready var maxCooldown := 3
@onready var cooldown := 0

#variaveis
var attacking: bool
var attackPower: int
var attackRightDirection := false

func _ready() -> void:
	#atualiza o valor maximo da barra de cooldown
	cooldownUI.max_value = maxCooldown
	#emite o sinal pra atualizar a barra de cooldown
	updateCooldown.emit(0)

func _process(_delta: float) -> void:
		#verifica se ja esta atacando
		if !attacking:
			#verifica se m1 foi clicado
			if Input.is_action_pressed("m1"):
				#aplica a direcao
				apply_direction()
				#verifica se o poder de ataque esta menor que 1500
				if attackPower >= 1500:
					#verifica se o cooldown acabou
					if cooldown == maxCooldown:
						#toca a animacao de carregamento2
						attackAnim.play("charge2")
				else:
					#adiciona 5 ao poder de ataque
					attackPower += 5
					#toca a animacao de carregamento
					verifyDirection("charge1", "charge1Left")
			#verifica se o m1 foi solto
			elif Input.is_action_just_released("m1"):
				#habilita o ataque
				attacking = true
				#verifica se o poder de ataque esta maior que 1500
				if attackPower >= 1500:
					#verifica se o cooldown acabou
					if cooldown == maxCooldown:
						#emite o sinal que o player comecou a atacar
						player.attackStarted.emit()
						#toca a animacao de ataque carregado
						attackAnim.play("chargedAttack")
						#toca o som do ataque carregado
						chargedAttackAudio.play()
						#habilita o ataque do player
						player.attacking = true
						#define a direcao do ataque
						var direction = get_global_mouse_position() - player.global_position
						#aplica a direcao no jogador
						player.velocity = direction.normalized() * attackPower
						player.get_node("sprite").visible = false
						#reseta o cooldown
						cooldown = 0
						#emite o sinal pra atualizar a barra de cooldown
						updateCooldown.emit(0)
					else:
						attackAudio.play()
						verifyDirection("unchargedAttack", "unchargedAttackLeft")
						changeDirection()
				else:
					attackAudio.play()
					verifyDirection("unchargedAttack", "unchargedAttackLeft")
					changeDirection()

func _on_attack_anim_animation_started(_anim) -> void:
	#verifica se e a animacao de carregar 2
	if _anim == "charge2":
		#toca o som da espada carregada
		chargeAudio.play()

func _on_attack_anim_animation_finished(_anim) -> void:
	#verifica se e a animacao de ataque carregado
	if _anim == "chargedAttack":
		#ativa a visibilidade do player
		player.get_node("sprite").visible = true
		#emite o sinal que o ataque acabou
		player.attackFinished.emit()
	#reseta o poder de ataque
	attackPower = 0
	#desabilita a variavel de ataque
	attacking = false
	#desabilita o ataque do player
	player.attacking = false

#funcao de mudar a direcao para o mouse
func apply_direction() -> void:
	var mouseDirection: Vector2 = (get_global_mouse_position() - global_position).normalized()
	rotation = mouseDirection.angle()
	if scale.y == 1 and mouseDirection.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouseDirection.x > 0:
		scale.y = 1

func _on_hitbox_area_entered(_area) -> void:
	#verifica se o poder de ataque esta menor que 1500
	if attackPower < 1500:
		#da dano ao inimigo
		_area.damage()
	else:
		#mata o inimigo
		_area.kill()
	#verifica se a area e um inimigo
	if _area.parent.is_in_group("enemies"):
		#aplica o efeito de dano na area
		_area.parent.get_node("hitAnim").play("hit")

#funcao que executa ao dar update no cooldown
func _on_update_cooldown(amount: int) -> void:
	#verifica se o cooldown e menor que o cooldown maximo
	if cooldown < maxCooldown:
		#diminui um no cooldown
		cooldown += amount
	#atualiza o valor da barra de cooldown
	cooldownUI.value = cooldown

func verifyDirection(animationRight: String, animationLeft: String) -> void:
	match attackRightDirection:
		true:
			attackAnim.play(animationRight)
		false:
			attackAnim.play(animationLeft)

func changeDirection() -> void:
	match attackRightDirection:
		true:
			attackRightDirection = false
		false:
			attackRightDirection = true
