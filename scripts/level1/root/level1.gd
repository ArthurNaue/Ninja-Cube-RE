extends Node2D
class_name Game

#constantes
const player = preload("res://scenes/level1/entities/player/root/player.tscn")

#variaveis onready
@onready var enemySpawnTimer = $enemySpawnTimer

#arrays
var enemySpawnPositions := [
	Vector2(120, 120),
	Vector2(120, 1600),
	Vector2(120, 2000),
	Vector2(1000, 120),
	Vector2(1000, 900),
	Vector2(1000, 1900),
	Vector2(2000, 120),
	Vector2(2000, 900),
	Vector2(2000, 1900),
	Vector2(2800, 120),
	Vector2(2800, 900),
	Vector2(2800, 1900)
	]

func _ready() -> void:
	GameManager.points = 0
	GameManager.currentLevel = self
	GameManager.spawnEntitie(player, Vector2(150, 220))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ESQ"):
		#verifica se os pontos feitos sao maior que os melhores pontos
		if GameManager.points > GameManager.bestScore:
			#atualiza os melhores pontos
			GameManager.bestScore = GameManager.points
		for child in get_children():
			remove_child(child)
			child.queue_free()
		get_tree().change_scene_to_file("res://scenes/startScreen/root/startScreen.tscn")

func _on_enemy_spawn_timer_timeout() -> void:
	if enemySpawnTimer.wait_time > 0.20:
		enemySpawnTimer.wait_time -= 0.005
	var enemySpawnPosition = enemySpawnPositions.pick_random()
	GameManager.spawnEntitie(EnemiesManager.enemies.pick_random(), enemySpawnPosition)
