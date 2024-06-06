extends RichTextLabel
class_name PointsEffect

#funcao de ajustar o texto de pontos
func adjust_points(points: int) -> void:
	#ajusta o texto pros pontos
	text = "[center]+" + str(points)

#funcao que executa quando o timer acaba
func _on_timer_timeout() -> void:
	#se auto-destroi
	queue_free()
