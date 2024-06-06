extends RichTextLabel
class_name HealthUI

#variaveis onready
@onready var healthUpdateAnim =  $healthUpdateAnim

func _ready() -> void:
	#muda o texto para a vida maxima do player
	text = "[center]" + str(3)

#funcao que executa quando o player toma dano
func player_damaged(health) -> void:
	#atualiza o texto pra vida do jogador
	text = "[center]" + str(health)
	#toca a animacao de atualizar a vida
	healthUpdateAnim.play("updateHealth")
