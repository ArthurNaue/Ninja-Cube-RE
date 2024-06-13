extends Node2D
class_name gameManager

#constantes
const powerupScene = preload("res://scenes/level1/powerups/root/powerup.tscn")

#variaveis
var gamePace := 1.0

func spawnEntitie(entitieScene: PackedScene, location: Vector2) -> void:
	var entitie = entitieScene.instantiate()
	entitie.global_position = location
	add_child(entitie)

func spawnPowerup(location: Vector2) -> void:
	var powerup = powerupScene.instantiate() as StaticBody2D
	call_deferred("add_child", powerup)
	powerup.global_position = location
