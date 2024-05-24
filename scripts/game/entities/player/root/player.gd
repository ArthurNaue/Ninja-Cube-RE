extends CharacterBody2D
class_name Player

#constantes
const shurikenScene = preload("res://scenes/game/entities/player/shuriken/root/shuriken.tscn")

#variaveis export
@export var stats: EntitieStats

#variaveis onready
@onready var sprite = $sprite
@onready var arrowSprite = $arrowSprite
@onready var canShoot = true
@onready var game = get_tree().get_first_node_in_group("game")

#variaveis
var moveVector: Vector2

func _physics_process(_delta) -> void:
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
		#zera a velocidade
		velocity = Vector2.ZERO
	
	#verifica se o player clicou com o mouse esquerdo
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
	shuriken.global_position = global_position
	shuriken.direction = get_global_mouse_position() - global_position
	if get_global_mouse_position().x > global_position.x:
		shuriken.facingRight = true
	#spawna o objeto do tiro
	get_parent().add_child(shuriken)

func _on_health_health_updated(health):
	game.playerDamaged.emit(health)
