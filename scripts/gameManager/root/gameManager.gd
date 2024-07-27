extends Node2D
class_name gameManager

#constantes
const powerupScene = preload("res://scenes/level1/powerups/root/powerup.tscn")

const triangleEnemyStats = preload("res://assets/resources/entitiesStats/enemies/normal/triangle/root/triangleEnemyStats.tres")
const circleEnemyStats = preload("res://assets/resources/entitiesStats/enemies/normal/circle/root/circleEnemyStats.tres")
const diamondEnemyStats = preload("res://assets/resources/entitiesStats/enemies/normal/diamond/root/diamondEnemyStats.tres")

#variaveis
var gamePace := 1.0
var timeStopped: bool
var currentLevel: Node2D

var enemyStats = [
	triangleEnemyStats,
	circleEnemyStats,
	diamondEnemyStats
]

func spawnEntitie(entitieScene: PackedScene, location: Vector2) -> void:
	var entitie = entitieScene.instantiate()
	currentLevel.call_deferred("add_child", entitie)
	entitie.global_position = location

func spawnPowerup(location: Vector2) -> void:
	var powerup = powerupScene.instantiate() as StaticBody2D
	currentLevel.call_deferred("add_child", powerup)
	powerup.global_position = location

func freeze_time() -> void:
	#ativa a variavel de tempo parado
	timeStopped = true
	#para o tempo
	for enemyStat in enemyStats:
		enemyStat.moveSpeed = 0
	#espera 5 segundos
	await get_tree().create_timer(5).timeout
	#retorna o tempo
	for enemyStat in enemyStats:
		enemyStat.moveSpeed = 150
	#desativa a variavel de tempo parado
	timeStopped = false

func nuke() -> void:
	#cria um array com todos os inimigos
	var enemies = get_tree().get_nodes_in_group("enemies")
	#mata todos os inimigos
	for enemy in enemies:
		enemy.get_node("hitbox").kill()
