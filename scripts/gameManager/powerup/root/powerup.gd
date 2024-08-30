extends StaticBody2D
class_name Powerup

#constantes
const healthSprite = preload("res://assets/images/gameManager/powerup/health/root/healthPowerup.png")
const shieldSprite = preload("res://assets/images/gameManager/powerup/shield/root/shieldPowerup.png")
const timeSprite = preload("res://assets/images/gameManager/powerup/time/root/timePowerup.png")
const speedSprite = preload("res://assets/images/gameManager/powerup/speed/root/speedPowerup.png")
const nukeSprite = preload("res://assets/images/gameManager/powerup/nuke/root/nukePowerup.png")

#variaveis onready
@onready var powerupSprite = $powerupSprite
@onready var pickupSound = $pickupSound
@onready var col = $hitbox/col
@onready var anim = $anim
@onready var player = get_tree().get_first_node_in_group("player")
@onready var playerHealth = player.get_node("health")
@onready var playerHitbox = player.get_node("hitbox")

#variaveis
var powerups = [
	"health",
	"shield",
	"time",
	"speed",
	"nuke"
]
var powerup: String

func _ready() -> void:
	#define o powerup
	powerup = set_powerup()

func _on_enable_timer_timeout() -> void:
	#habilita a colisao
	col.disabled = false

func _on_hitbox_area_entered(_area: Area2D) -> void:
	#verifica se a area colidida e um player
	if _area.parent.is_in_group("player"):
		#executa a funcao de pegar o powerup
		powerup_picked()

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
func powerup_picked() -> void:
	match powerup:
		"health":
			#verifica se o player esta com a vida maxima
			if playerHealth.health < playerHealth.maxHealth:
				#cura
				playerHitbox.heal()
				#desabilita o powerup
				disable_powerup()
		"shield":
			#verifica se o player esta com o escudo ativo
			if !player.shielded:
				#ativa o shield
				playerHitbox.shield()
				#desabilita o powerup
				disable_powerup()
		"time":
			#verifica se o tempo ja nao esta parado
			if !GameManager.timeStopped:
				#para o tempo
				GameManager.freeze_time()
				#desabilita o powerup
				disable_powerup()
		"speed":
			#veririca se o powerup de velocidade ja nao esta ativo
			if !player.boosted:
				#da um boost de velocidade ao player
				player.speed_powerup()
				#desabilita o powerup
				disable_powerup()
		"nuke":
			#mata todos os inimigos
			GameManager.nuke()
			#desabilita o powerup
			disable_powerup()

func set_powerup() -> String:
	#define qual vai ser o powerup
	var chosenPowerup = powerups.pick_random()
	match chosenPowerup:
		"health":
			powerupSprite.texture = healthSprite
		"shield":
			powerupSprite.texture = shieldSprite
		"time":
			powerupSprite.texture = timeSprite
		"speed":
			powerupSprite.texture = speedSprite
		"nuke":
			powerupSprite.texture = nukeSprite
	#retorna o powerup escolhido
	return chosenPowerup

#funcao que desabilita o powerup
func _on_disable_timer_timeout() -> void:
	#toca a animacao de desaparecer
	anim.play("disable")
	#espera 30 segundos
	await get_tree().create_timer(30).timeout
	#deleta o objeto de powerup
	queue_free()
