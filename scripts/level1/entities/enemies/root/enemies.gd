extends CharacterBody2D
class_name Enemies

#variaveis onready
@onready var game = get_tree().get_first_node_in_group("game")

#variaveis
var enemy1 = load("res://scenes/level1/entities/enemies/normal/triangle/root/triangleEnemy.tscn")
var enemy2 = load("res://scenes/level1/entities/enemies/normal/circle/root/circleEnemy.tscn")
var enemies = [
	enemy1,
	enemy2
]

#funcao de seguir o player
func follow_player(enemy: CharacterBody2D) -> void:
	#define a direcao pro player
	var dir = to_local(enemy.get_node("navAgentComponent").get_next_path_position()).normalized()
	#ajusta a velocidade do inimigo
	enemy.velocity = (dir * enemy.stats.moveSpeed) * GameManager.gamePace
