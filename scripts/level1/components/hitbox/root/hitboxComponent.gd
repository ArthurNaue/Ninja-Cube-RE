extends Area2D
class_name HitboxComponent

#constantes
const shieldScene = preload("res://scenes/level1/powerups/shield/effect/root/shieldEffect.tscn")

#variaveis export
@export var health: HealthComponent
@export var hitAnim: AnimationPlayer

#variaveis onready
@onready var parent = get_parent()
@onready var col = $col

#funcao de causar dano ao objeto
func damage() -> void:
	#destroi o objeto
	health.damage()

#funcao de matar o objeto
func kill() -> void:
	#executa a funcao de matar o objeto na vida
	health.kill()

#funcao de curar o objeto
func heal() -> void:
	#executa a cura na vida
	health.heal()

func shield() -> void:
	var shieldEffect = shieldScene.instantiate() as StaticBody2D
	parent.call_deferred("add_child", shieldEffect)
