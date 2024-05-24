extends Node2D
class_name Sword

#variaveis onready
@onready var attackAnim = $attackAnim

#variaveis
var isAttacking: bool

func _process(_delta: float) -> void:
	#verifica se esta atacando
	if isAttacking == false:
		#verifica se m1 foi clicado
		if Input.is_action_just_pressed("m1"):
			#habilita a variavel de ataque
			isAttacking = true
			#toca a animacao de ataque
			attackAnim.play("attack")
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

func _on_attack_anim_animation_finished(_attack) -> void:
	#desabilita o ataque
	isAttacking = false

func _on_hitbox_area_entered(_area) -> void:
	#destroi o inimigo
	_area.damage()
	if _area.parent.is_in_group("enemies"):
		_area.parent.get_node("hitAnim").play("hit")
