extends Area2D

var boss 
var cameraBoss
var moverse = false
var player 
var audio
var audioAnterior
func _ready():
	audioAnterior =get_parent().get_node("AudioStreamPlayer2D")
	audio = get_parent().get_node("MusicaBoss")
	self.connect("body_entered",self,"fijarCamara")
	boss  = get_parent().get_node("EnemyBoss")
	cameraBoss = get_parent().get_node("CameraBoss")
func fijarCamara(target):
	if target.name.begins_with("Player"):
		#target.camera.current = false
		player = target
		moverse = true
		audioAnterior.stop()
		audio.play(0)
		boss.player = target
		#cameraBoss.current = true
		#boss.set_process(true)
		#self.queue_free()
		
func _process(delta):	
	if moverse and player.camera.global_position.x < cameraBoss.position.x + 100:
		player.camera.moverseHaciaLaOtraCamara(cameraBoss)
		player.set_process(false)
		player.AnimationController.Stop()
		player.AnimationController.Normal()
		
	elif player != null:
		player.set_process(true)
		player.camera.current = false
		cameraBoss.current = true
		boss.set_process(true)
		self.queue_free()