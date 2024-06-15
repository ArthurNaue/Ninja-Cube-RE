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
	GameManager.spawnEntitie(player, Vector2(150, 220))

func _on_enemy_spawn_timer_timeout() -> void:
	if enemySpawnTimer.wait_time > 0.20:
		enemySpawnTimer.wait_time -= 0.005
	var enemySpawnPosition = enemySpawnPositions.pick_random()
	GameManager.spawnEntitie(EnemiesManager.enemies.pick_random(), enemySpawnPosition)
