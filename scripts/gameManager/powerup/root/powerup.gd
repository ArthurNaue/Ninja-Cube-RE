extends StaticBody2D
class_name Powerup

#constantes
const healthSprite = preload("res://assets/images/gameManager/powerup/health/root/healthPowerup.png")
const shieldSprite = preload("res://assets/images/gameManager/powerup/shield/root/shieldPowerup.png")

#variaveis onready
@onready var powerupSprite = $powerupSprite
@onready var pickupSound = $pickupSound
@onready var col = $hitbox/col
@onready var playerHitbox = get_tree().get_first_node_in_group("player").get_node("hitbox")

#variaveis
var powerups = [
	"health",
	"shield"
]
var chosenPowerup: String

func _ready() -> void:
	set_powerup()

func _on_enable_timer_timeout() -> void:
	#habilita a colisao
	col.disabled = false

func _on_hitbox_area_entered(_area: Area2D) -> void:
	#verifica se a area colidida e um player
	if _area.parent.is_in_group("player"):
		#executa a funcao de pegar o powerup
		powerup_picked(chosenPowerup)

#funcao que executa quando o som de pickup acaba
func _on_pickup_sound_finished() -> void:
	#deleta o objeto do powerup
	queue_free()

#funcao de desabilitar o powerup
func disable_powerup() -> void:
	#desativa a colisao
	col.set_deferred("disabled", true)
	#desativa a visibilidade do powerup
	visible = false
	#toca o som de pegar o powerup
	pickupSound.play()

#funcao de curar
func powerup_picked(_powerup: String) -> void:
	match _powerup:
		"health":
			#cura
			playerHitbox.heal()
		"shield":
			#ativa o shield
			playerHitbox.shield()
	#desabilita o powerup
	disable_powerup()

func set_powerup():
	#define qual vai ser o powerup
	chosenPowerup = powerups.pick_random()
	match chosenPowerup:
		"health":
			powerupSprite.texture = healthSprite
		"shield":
			powerupSprite.texture = shieldSprite
