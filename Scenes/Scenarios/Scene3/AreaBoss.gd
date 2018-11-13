extends Area2D

var boss 
var cameraBoss
func _ready():
	self.connect("body_entered",self,"fijarCamara")
	boss  = get_parent().get_node("EnemyBoss")
	cameraBoss = get_parent().get_node("CameraBoss")
func fijarCamara(target):
	if target.name.begins_with("Player"):
		target.camera.current = false
		cameraBoss.current = true
		boss.set_process(true)
		self.queue_free()