extends StaticBody2D
class_name ShieldEffect

#variaveis onready
@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim = $anim

func _ready() -> void:
	#habilita o shield no player
	player.shielded = true

func _on_timer_timeout() -> void:
	anim.play("end")
	await get_tree().create_timer(0.1).timeout
	#desabilita o shield no player
	player.shielded = false
	queue_free()
