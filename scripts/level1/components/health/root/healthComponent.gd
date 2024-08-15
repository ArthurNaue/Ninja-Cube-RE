extends Node2D
class_name HealthComponent

#sinais
signal healthUpdated(health: int)

#constantes
const pointsEffectScene = preload("res://scenes/level1/entities/player/hud/pointsEffect/root/pointsEffect.tscn")
const powerupScene = preload("res://scenes/level1/powerups/root/powerup.tscn")

#variaveis export
@export var healthBar: HealthBarComponent

#variaveis onready
@onready var parent = get_parent()
@onready var maxHealth = parent.stats.maxHealth
@onready var health = maxHealth
@onready var game = get_tree().get_first_node_in_group("game")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sword = get_tree().get_first_node_in_group("sword")

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
		#emite o sinal de tomar dano
		parent.dmg.emit()
	#atualiza a vida
	update_health()

func kill() -> void:
	#diminui a vida pela vida maxima
	health -= maxHealth
	#atualiza a vida
	update_health()

func heal() -> void:
	#verifica se o player nao esta com a vida maxima
	if health < maxHealth:
		#aumenta a vida por um
		health += 1
		#manda o sinal de atualizar a vida
		healthUpdated.emit(health)

func update_health() -> void:
	#mata a entidade se a vida chegar a zero
	if health <= 0:
		#verifica se a entidade e um inimigo
		if parent.is_in_group("enemies"):
			#spawna o efeito de pontos
			spawn_points_effect(parent.global_position, 1)
			#diminui um no cooldown da espada
			sword.updateCooldown.emit(1)
			#randomiza um numero pra ver se spawna o powerup
			var shouldSpawnPowerup = randi_range(1, 15)
			#se o numero escolhido for 1
			if shouldSpawnPowerup == 1:
				#spawna o powerup
				GameManager.spawnEntitie(powerupScene, parent.global_position)
		else:
			#verifica se os pontos feitos sao maior que os melhores pontos
			if GameManager.points > GameManager.bestScore:
				#atualiza os melhores pontos
				GameManager.bestScore = GameManager.points
			#deleta todos os objetos do jogo
			for child in game.get_children():
				remove_child(child)
				child.queue_free()
			#muda pra cena de replay
			get_tree().change_scene_to_file("res://scenes/deathScreen/root/deathScreen.tscn")
	#manda o sinal de atualizar a vida
	healthUpdated.emit(health)

func spawn_points_effect(location: Vector2, points: int) -> void:
	#adiciona aos pontos do jogador
	GameManager.points += points
	#emite o sinal que atualiza os pontos do player
	player.pointsUpdated.emit(GameManager.points)
	#cria o objeto do efeito de pontos
	var pointsEffect = pointsEffectScene.instantiate() as RichTextLabel
	#executa a funcao que atualiza os pontos do objeto
	pointsEffect.adjust_points(points)
	#adiciona o objeto no jogo
	game.add_child(pointsEffect)
	#deleta a entidade
	parent.queue_free()
	#atualiza a posicao do objeto do efeito de pontos
	pointsEffect.global_position = location

