extends Node2D
class_name SwordDirection

func _process(_delta: float) -> void:
	#aplica a direcao
	apply_direction()

#funcao de mudar a direcao para o mouse
func apply_direction() -> void:
	var mouseDirection: Vector2 = (get_global_mouse_position() - global_position).normalized()
	rotation = mouseDirection.angle()
	if scale.y == 1 and mouseDirection.x < 0:
		scale.y = -1
	elif scale.y == -1 and mouseDirection.x > 0:
		scale.y = 1
