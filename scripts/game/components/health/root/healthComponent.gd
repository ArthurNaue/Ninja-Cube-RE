extends Node2D
class_name HealthComponent

signal healthUpdated(health: int)

#variaveis export
@export var healthBar: HealthBarComponent

#variaveis onready
@onready var parent = get_parent()
@onready var maxHealth = parent.stats.maxHealth
@onready var health = maxHealth
@onready var game = get_tree().get_first_node_in_group("game")

func _ready() -> void:
	if healthBar != null:
		healthBar.max_value = maxHealth
		healthBar.value = maxHealth

func damage() -> void:
	#diminui a vida por um
	health -= 1
	#mata a entidade se a vida chegar a zero
	if health <= 0:
		parent.queue_free()
	#manda o sinal de atualizar a vida
	healthUpdated.emit(health)
