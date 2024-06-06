extends CharacterBody2D
class_name Player

#sinais
signal pointsUpdated(points)

#constantes
const shurikenScene = preload("res://scenes/game/entities/player/shuriken/root/shuriken.tscn")

#variaveis export
@export var stats: EntitieStats

#variaveis onready
@onready var sprite = $sprite
@onready var arrowSprite = $arrowSprite
@onready var canShoot = true
@onready var game = get_tree().get_first_node_in_group("game")
@onready var col = $hitbox/col
@onready var healthUI = $hud/healthUI

#variaveis
var moveVector: Vector2
var attacking: bool
var points: int

func _physics_process(_delta) -> void:
	if attacking == false:
		col.disabled = false
		#adiciona a direcao do player ao input
		moveVector.x = Input.get_action_strength("D") - Input.get_action_strength("A")
		moveVector.y = Input.get_action_strength("S") - Input.get_action_strength("W")
		#estabiliza os numeros do Vector2
		moveVector = moveVector.normalized()
		
		if get_global_mouse_position().x < global_position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		
		#verifica se tem alguma direcao para ir
		if moveVector:
			#altera a velocidade do player baseado na direcao 
			velocity = moveVector * (stats.moveSpeed * game.gamePace)
		else:
			velocity = Vector2.ZERO
	else:
		col.disabled = true
	
	#verifica se o player clicou com o mouse direito
	if Input.is_action_just_pressed("m2"):
		#verifica se pode atirar
		if canShoot == true:
			#atira
			shoot()

	#adiciona movimento ao jogador
	move_and_slide()

#funcao de atirar
func shoot() -> void:
	#desativa a habilidade de atirar
	canShoot = false
	#cria o objeto do tiro
	var shuriken = shurikenScene.instantiate() as CharacterBody2D
	#ajusta a posicao do objeto do tiro
	shuriken.global_position = global_position
	#ajusta a direcao do objeto do tiro
	shuriken.direction = get_global_mouse_position() - global_position
	#ajusta o lado que o objeto do tiro esta direcionado
	if get_global_mouse_position().x > global_position.x:
		shuriken.facingRight = true
	#spawna o objeto do tiro
	get_parent().add_child(shuriken)

func _on_health_health_updated(health):
	healthUI.player_damaged(health)
