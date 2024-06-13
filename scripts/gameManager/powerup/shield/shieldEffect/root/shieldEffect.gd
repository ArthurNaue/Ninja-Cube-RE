extends StaticBody2D
class_name ShieldEffect

#variaveis onready
@onready var anim = $anim

func _on_timer_timeout() -> void:
	anim.play("end")
	await get_tree().create_timer(0.1).timeout
	queue_free()
