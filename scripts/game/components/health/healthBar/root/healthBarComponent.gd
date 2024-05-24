extends ProgressBar
class_name HealthBarComponent

func _on_health_health_updated(health):
		#faz a barra de vida ficar visivel
		visible = true
		#atualiza o valor da barra de vida
		value = health
		await get_tree().create_timer(0.4).timeout
		#faz a barra de vida ficar invisivel
		visible = false
