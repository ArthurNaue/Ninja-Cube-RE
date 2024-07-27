extends Node2D
class_name Shuriken

#constantes
const shurikenProjectileScene = preload("res://scenes/level1/entities/player/shuriken/projectile/root/shurikenProjectile.tscn")
const killEffectScene = preload("res://scenes/level1/entities/player/kill_effect/root/killEffect.tscn")

#variaveis onready
@onready var game = get_tree().get_first_node_in_group("game")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var tpShootAudio = $tpShootAudio
@onready var canShoot = true

func _physics_process(_delta) -> void:
	#verifica se o player clicou com o mouse direito
	if Input.is_action_just_pressed("m2"):
		#verifica se pode atirar
		if canShoot == true:
			#atira
			shoot()

#funcao de atirar
func shoot() -> void:
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
