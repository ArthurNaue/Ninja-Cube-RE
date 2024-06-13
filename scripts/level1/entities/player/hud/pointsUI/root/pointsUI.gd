extends RichTextLabel
class_name pointsUI

#variaveis onready
@onready var pointsUpdateAnim =  $pointsUpdateAnim

func _ready() -> void:
	#zera os pontos do jogador
	text = "[center]0" 

func _on_player_points_updated(points) -> void:
	#atualiza o texto pros pontos do jogador
	text = "[center]" + str(points)
	#toca a animacao de atualizar os pontos
	pointsUpdateAnim.play("updatePoints")
