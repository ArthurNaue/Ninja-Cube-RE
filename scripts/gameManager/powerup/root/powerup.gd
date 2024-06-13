extends StaticBody2D
class_name Powerup

#constantes
const healthSprite = preload("res://assets/images/gameManager/powerup/health/root/healthPowerup.png")
const shieldSprite = preload("res://assets/images/gameManager/powerup/shield/root/shieldPowerup.png")

#variaveis onready
@onready var powerupSprite = $powerupSprite
@onready var pickupSound = $pickupSound
@onready var col = $hitbox/col

#variaveis
var powerups = [
	"health",
	"shield"
]
var chosenPowerup: String

func _ready() -> void:
	#define qual vai ser o powerup
	chosenPowerup = powerups.pick_random()
	match chosenPowerup:
		"health":
			powerupSprite.texture = healthSprite
		"shield":
			powerupSprite.texture = shieldSprite

func _on_enable_timer_timeout():
	#habilita a colisao
	col.disabled = false

func _on_hitbox_area_entered(_area: Area2D):
	#verifica se a area colidida e um player
	if _area.parent.is_in_group("player"):
		#desativa a colisao
		col.disabled = true
		#desativa a visibilidade do powerup
		visible = false
		#toca o som de pegar o powerup
		pickupSound.play()
		#verifica qual o powerup escolhido
		match chosenPowerup:
			"health":
				#cura o player
				_area.heal()
			"shield":
				#da um shield ao player
				_area.shield()

#funcao que executa quando o som de pickup acaba
func _on_pickup_sound_finished():
	#deleta o objeto do powerup
	queue_free()
