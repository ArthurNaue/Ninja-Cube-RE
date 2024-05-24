extends Area2D
class_name HitboxComponent

#variaveis export
@export var health: HealthComponent
@export var hitAnim: AnimationPlayer

#variaveis onready
@onready var parent = get_parent()

#funcao de causar dano ao objeto
func damage() -> void:
	#destroi o objeto
	health.damage()
