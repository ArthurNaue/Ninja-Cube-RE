extends Enemies
class_name Enemy

#variaveis export
@export var stats: EntitieStats

#variaveis onready
@onready var sprite := $sprite
@onready var player := get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	follow_player(self)
	
	if velocity.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	#executa o movimento
	move_and_slide()

func _on_hitbox_area_entered(_area) -> void:
	if _area.parent.is_in_group("player"):
		_area.damage()
