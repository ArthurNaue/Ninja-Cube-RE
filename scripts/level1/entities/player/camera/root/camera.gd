extends Camera2D
class_name PlayerCamera

const maxDistance = 48

var targetDistance = 0
var centerPos = position
var shakeFade: float = 5.0
var rng = RandomNumberGenerator.new()
var shakeStrength: float = 0.0

func _process(_delta: float) -> void:
	var direction = centerPos.direction_to(get_local_mouse_position())
	var targetPos = centerPos + direction * targetDistance
	
	targetPos = targetPos.clamp(
		centerPos - Vector2(maxDistance, maxDistance),
		centerPos + Vector2(maxDistance, maxDistance)
	)
	
	if shakeStrength > 0:
		shakeStrength = lerp(shakeStrength, 0.0, shakeFade * _delta)
		
		offset = random_offset()
	
	position = targetPos

func _input(_event) -> void:
	if _event is InputEventMouseMotion:
		targetDistance = centerPos.distance_to(get_local_mouse_position()) / 4

func apply_shake(randomStrength: float) -> void:
	shakeStrength = randomStrength

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))

