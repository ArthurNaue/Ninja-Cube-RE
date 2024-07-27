extends CharacterBody2D
class_name ShurikenProjectile

#constantes
const moveSpeed = 6

#variaveis onready
@onready var sprite = $sprite
@onready var spinAnim = $spinAnim
@onready var game = get_tree().get_first_node_in_group("game")

#variaveis
var shuriken: Node2D
var direction: Vector2
var targets: Array
var facingRight: bool

func _ready() -> void:
	#rotaciona a shuriken pra direcao certa
	if facingRight == true:
		spinAnim.play("facingRight")
	else:
		spinAnim.play("facingLeft")

func _physics_process(_delta: float) -> void:
	#verifica se tem algum alvo detectado
	if targets.size() > 0:
		#ativa a camera lenta
		GameManager.gamePace = 0.1
	else:
		#desativa a camera lenta
		GameManager.gamePace = 1
	
	#verifica se o m1 foi clicado
	if Input.is_action_just_pressed("m2"):
		#verifica se tem algum objeto detectado
		if targets.size() > 0:
			#repete a habilidade para cada alvo
			for target in targets:
				#ativa a habilidade de matar o objeto
				shuriken.tp_shoot(target)
			#ativa as particulas do tiro
			shuriken.kill_effect(shuriken.player.global_position)
		else:
			shuriken.change_position(global_position)
	
	#aplica movimento na bala
	var collision = move_and_collide(direction.normalized() * (moveSpeed * GameManager.gamePace))
	
	if collision:
		shuriken.change_position(global_position)

#verifica se alguma hitbox colidiu com a area
func _on_hitbox_component_area_entered(area: Area2D) -> void:
	#adiciona o inimigo pro array de alvos
	targets.append(area)
	#faz o inimigo ficar branco
	area.hitAnim.play("areaEntered")

func _on_hitbox_component_area_exited(area) -> void:
	#retira o inimigo do array de alvos
	targets.erase(area)
	#faz o inimigo voltar ao normal
	area.hitAnim.play("areaExited")

#funcao de desenhar o circulo da hitbox
func _draw() -> void:
	#define os parametros do circulo
	var cen = Vector2.ZERO
	var rad = 40
	var col = Color(214, 212, 203, 1)
	var angle_from = 0
	var angle_to = 359
	#desenha o circulo
	draw_arc(cen, rad, angle_from, angle_to, 100, col, 2)
