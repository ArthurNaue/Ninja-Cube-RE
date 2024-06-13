extends Node2D
class_name HealthComponent

#sinais
signal healthUpdated(health: int)

#constantes
const pointsEffectScene = preload("res://scenes/level1/entities/player/hud/pointsEffect/root/pointsEffect.tscn")

#variaveis export
@export var healthBar: HealthBarComponent

#variaveis onready
@onready var parent = get_parent()
@onready var maxHealth = parent.stats.maxHealth
@onready var health = maxHealth
@onready var game = get_tree().get_first_node_in_group("game")
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	#verifica se a barra de vida ta vazia
	if healthBar != null:
		#ajusta a vida da barra de vida pro valor maximo da vida
		healthBar.max_value = maxHealth
		#ajusta o valor da barra de vida pro valor da vida
		healthBar.value = maxHealth

func damage() -> void:
	#diminui a vida por um
	health -= 1
	#verifica se a entidade e o player
	if parent.is_in_group("player"):
		#toca o som de tomar dano
		parent.hitAudio.play()
	#mata a entidade se a vida chegar a zero
	if health <= 0:
		#verifica se a entidade e um inimigo
		if parent.is_in_group("enemies"):
			#spawna o efeito de pontos
			spawn_points_effect(parent.global_position, 1)
			var shouldSpawnPowerup = randi_range(1, 20)
			if shouldSpawnPowerup == 1:
				GameManager.spawnPowerup(parent.global_position)
		else:
			parent.queue_free()
	#manda o sinal de atualizar a vida
	healthUpdated.emit(health)

func heal() -> void:
	#verifica se o player nao esta com a vida maxima
	if health < maxHealth:
		#aumenta a vida por um
		health += 1
		#manda o sinal de atualizar a vida
		healthUpdated.emit(health)

func spawn_points_effect(location: Vector2, points: int) -> void:
	#adiciona aos pontos do jogador
	player.points += points
	#emite o sinal que atualiza os pontos do player
	player.pointsUpdated.emit(player.points)
	#cria o objeto do efeito de pontos
	var pointsEffect = pointsEffectScene.instantiate() as RichTextLabel
	#atualiza a posicao do objeto do efeito de pontos
	pointsEffect.global_position = location
	#executa a funcao que atualiza os pontos do objeto
	pointsEffect.adjust_points(points)
	#adiciona o objeto no jogo
	game.add_child(pointsEffect)
	parent.queue_free()
