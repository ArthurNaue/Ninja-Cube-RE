extends Node2D
class_name Game

#constantes
const player = preload("res://scenes/game/entities/player/root/player.tscn")

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

#variaveis
var gamePace := 1.0

func _ready() -> void:
	spawnEntitie(player, Vector2(150, 220))

func spawnEntitie(entitieScene: PackedScene, location: Vector2) -> void:
	var entitie = entitieScene.instantiate()
	entitie.global_position = location
	add_child(entitie)

func _on_enemy_spawn_timer_timeout() -> void:
	var enemySpawnPosition = enemySpawnPositions.pick_random()
	spawnEntitie(EnemiesManager.enemy1, enemySpawnPosition)
