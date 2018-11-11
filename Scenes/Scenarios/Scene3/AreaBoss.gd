extends Area2D


func _ready():
	self.connect("body_entered",self,"fijarCamara")
	
func fijarCamara(target):
	target.remove_child(target.camera)
	get_parent().add_child(target.camera)
	target.camera.position = target.position
	self.queue_free()