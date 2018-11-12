extends Area2D

var boss 
var cameraBoss
func _ready():
	self.connect("body_entered",self,"fijarCamara")
	boss  = get_parent().get_node("EnemyBoss")
	cameraBoss = get_parent().get_node("CameraBoss")
func fijarCamara(target):
	target.camera.current = false
	cameraBoss.current = true
	boss.set_process(true)
	boss.start()
	self.queue_free()