extends NavigationAgent2D
class_name NavAgentComponent

#variaveis onready
@onready var parent = get_parent()
@onready var player = get_tree().get_first_node_in_group("player")

#variaveis
var cooldown := 0.2

func _physics_process(_delta: float) -> void:
	#diminui o cooldown por delta
	cooldown -= _delta

	#verifica se o cooldown acabou
	if cooldown <= 0:
		#define o caminho
		make_path()

#funcao de definir o caminho
func make_path() -> void:
	if player != null:
		#define a posicao do player
		target_position = player.global_position
	#reinicia o cooldown
	cooldown = 0.2
