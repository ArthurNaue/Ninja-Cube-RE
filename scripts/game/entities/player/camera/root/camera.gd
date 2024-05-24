extends Camera2D
class_name PlayerCamera

const maxDistance = 48

var targetDistance = 0
var centerPos = position

func _process(_delta) -> void:
	var direction = centerPos.direction_to(get_local_mouse_position())
	var targetPos = centerPos + direction * targetDistance
	
	targetPos = targetPos.clamp(
		centerPos - Vector2(maxDistance, maxDistance),
		centerPos + Vector2(maxDistance, maxDistance)
	)
	
	position = targetPos

func _input(_event) -> void:
	if _event is InputEventMouseMotion:
		targetDistance = centerPos.distance_to(get_local_mouse_position()) / 4
