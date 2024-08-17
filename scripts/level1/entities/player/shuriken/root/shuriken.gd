extends Node2D
class_name Shuriken

#sinais
signal updateCooldown(amount: int)

#constantes
const shurikenProjectileScene = preload("res://scenes/level1/entities/player/shuriken/projectile/root/shurikenProjectile.tscn")
const killEffectScene = preload("res://scenes/level1/entities/player/kill_effect/root/killEffect.tscn")

#variaveis onready
@onready var game = get_tree().get_first_node_in_group("game")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var tpShootAudio = $tpShootAudio
@onready var shootAudio = $shootAudio
@onready var cooldownUI = $hudLayer/cooldownUI
@onready var canShoot = true
@onready var maxCooldown := 5
@onready var cooldown := 0

func _ready() -> void:
	#atualiza o valor maximo da barra de cooldown
	cooldownUI.max_value = maxCooldown
	#emite o sinal pra atualizar a barra de cooldown
	updateCooldown.emit(0)

func _physics_process(_delta) -> void:
	#verifica se o player clicou com o mouse direito
	if Input.is_action_just_pressed("m2"):
		#verifica se o cooldown acabou
		if cooldown == maxCooldown:
			#verifica se pode atirar
			if canShoot == true:
				#atira
				shoot()

#funcao de atirar
func shoot() -> void:
	#toca o audio de atirar
	shootAudio.play()
	#desativa a habilidade de atirar
	canShoot = false
	#cria o objeto do tiro
	var shurikenProjectile = shurikenProjectileScene.instantiate() as CharacterBody2D
	#ajusta a direcao do objeto do tiro
	shurikenProjectile.direction = get_global_mouse_position() - player.global_position
	shurikenProjectile.shuriken = self
	#ajusta o lado que o objeto do tiro esta direcionado
	if get_global_mouse_position().x > player.global_position.x:
		shurikenProjectile.facingRight = true
	#spawna o objeto do tiro
	game.add_child(shurikenProjectile)
	#ajusta a posicao do objeto do tiro
	shurikenProjectile.global_position = player.global_position
	#reseta o cooldown
	cooldown = 0
	#emite o sinal pra atualizar a barra de cooldown
	updateCooldown.emit(0)

#funcao de trocar de posicao do player com a bala
func change_position(desiredPosition: Vector2) -> void:
	#muda a posicao da bala e do player
	player.global_position = desiredPosition
	#habilita o player a atirar
	canShoot = true
	#deleta o projetil de shuriken
	game.get_node("shurikenProjectile").queue_free()

func tp_shoot(area: Area2D) -> void:
	#troca a posicao do player com a bala
	change_position(area.parent.global_position)
	#mata o objeto
	area.kill()
	#desativa a camera lenta
	GameManager.gamePace = 1
	#toca o som de tp shoot
	tpShootAudio.play()
	#aplica o camera shake
	player.camera.apply_shake(4.0)
	#deleta o projetil de shuriken
	game.get_node("shurikenProjectile").queue_free()

#funcao de spawnar os kill effect
func kill_effect(location: Vector2) -> void:
	var killEffect = killEffectScene.instantiate() as CPUParticles2D
	player.add_child(killEffect)
	killEffect.global_position = location
	killEffect.emitting = true

#funcao que atualiza o cooldown
func _on_update_cooldown(amount: int) -> void:
	#verifica se o cooldown e menor que o cooldown maximo
	if cooldown < maxCooldown:
		#diminui um no cooldown
		cooldown += amount
	#atualiza o valor da barra de cooldown
	cooldownUI.value = cooldown
