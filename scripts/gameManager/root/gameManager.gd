extends Node2D
class_name gameManager

#constantes
const powerupScene = preload("res://scenes/level1/powerups/root/powerup.tscn")
const enemyStats = preload("res://assets/resources/entitiesStats/enemies/normal/triangle/root/triangleEnemyStats.tres")

#variaveis
var gamePace := 1.0
var timeStopped: bool

func spawnEntitie(entitieScene: PackedScene, location: Vector2) -> void:
	var entitie = entitieScene.instantiate()
	entitie.global_position = location
	add_child(entitie)

func spawnPowerup(location: Vector2) -> void:
	var powerup = powerupScene.instantiate() as StaticBody2D
	call_deferred("add_child", powerup)
	powerup.global_position = location

func freeze_time() -> void:
	#ativa a variavel de tempo parado
	timeStopped = true
	#para o tempo
	enemyStats.moveSpeed = 0
	#espera 5 segundos
	await get_tree().create_timer(5).timeout
	#retorna o tempo
	enemyStats.moveSpeed = 150
	#desativa a variavel de tempo parado
	timeStopped = false
