extends Area2D

var boss 
var cameraBoss
var moverse = false
var player 
func _ready():
	self.connect("body_entered",self,"fijarCamara")
	boss  = get_parent().get_node("EnemyBoss")
	cameraBoss = get_parent().get_node("CameraBoss")
func fijarCamara(target):
	if target.name.begins_with("Player"):
		#target.camera.current = false
		player = target
		moverse = true
		#cameraBoss.current = true
		#boss.set_process(true)
		#self.queue_free()
		
func _process(delta):	
	if moverse and player.camera.global_position.x < cameraBoss.position.x:
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