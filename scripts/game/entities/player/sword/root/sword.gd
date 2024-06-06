extends Node2D
class_name Sword

#variaveis onready
@onready var attackAnim = $attackAnim
@onready var sprite = $sprite
@onready var player = get_tree().get_first_node_in_group("player")

#variaveis
var attacking: bool
var attackPower: int

func _process(_delta: float) -> void:
		#verifica se ja esta atacando
		if !attacking:
			#verifica se m1 foi clicado
			if Input.is_action_pressed("m1"):
				#aplica a direcao
				apply_direction()
				#adiciona 5 ao poder de ataque
				attackPower += 5
				#verifica se o poder de ataque esta menor que 1500
				if attackPower >= 1500:
					#limita o ataque em 1500
					attackPower = 1500
					#toca a animacao de carregamento2
					attackAnim.play("charge2")
				else:
					#toca a animacao de carregamento1
					attackAnim.play("charge1")
			#verifica se o m1 foi solto
			elif Input.is_action_just_released("m1"):
				#habilita o ataque
				attacking = true
				#verifica se o poder de ataque esta maior que 1500
				if attackPower >= 1500:
					#habilita o ataque do player
					player.attacking = true
					#define a direcao do ataque
					var direction = get_global_mouse_position() - player.global_position
					#aplica a direcao no jogador
					player.velocity = direction.normalized() * attackPower
				#toca a animacao de ataque
				attackAnim.play("attack")

#funcao de mudar a direcao para o mouse
func apply_direction() -> void:
	var mouseDirection: Vector2 = (get_global_mouse_position() - global_position).normalized()
	rotation = mouseDirection.angle()
	if scale.y == 1 and mouseDirection.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouseDirection.x > 0:
		scale.y = 1

func _on_attack_anim_animation_finished(_attack) -> void:
	#reseta o poder de ataque
	attackPower = 0
	#desabilita a variavel de ataque
	attacking = false
	#desabilita o ataque do player
	player.attacking = false

func _on_hitbox_area_entered(_area) -> void:
	#verifica se o poder de ataque esta menor que 1500
	if attackPower < 1500:
		#da dano ao inimigo
		_area.damage()
	else:
		#destroi o inimigo
		_area.parent.queue_free()
	#verifica se a area e um inimigo
	if _area.parent.is_in_group("enemies"):
		#aplica o efeito de dano na area
		_area.parent.get_node("hitAnim").play("hit")
