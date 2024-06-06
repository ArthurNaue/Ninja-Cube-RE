extends RichTextLabel
class_name PointsEffect

func adjust_points(points: int) -> void:
	text = "[center]+" + str(points)

#funcao que executa quando o timer acaba
func _on_timer_timeout() -> void:
	#se auto-destroi
	queue_free()
