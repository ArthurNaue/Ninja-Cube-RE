extends CharacterBody2D
class_name Enemies

#variaveis onready
@onready var game = get_tree().get_first_node_in_group("game")

#variaveis
var enemy1 = load("res://scenes/game/entities/enemies/normal/enemy/root/enemy.tscn")

#funcao de seguir o player
func follow_player(enemy: CharacterBody2D) -> void:
	#define a direcao pro player
	var dir = to_local(enemy.get_node("navAgentComponent").get_next_path_position()).normalized()
	#ajusta a velocidade do inimigo
	enemy.velocity = (dir * enemy.stats.moveSpeed) * game.gamePace
