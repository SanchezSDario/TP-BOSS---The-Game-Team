extends Area2D

export var velocidad = 0
var padre
func _ready():
	self.connect("body_entered",self,"golpear")	
	padre = get_parent()
	
func _process(delta):	
	caer()
	
func caer():
	padre.move_and_collide(Vector2(0,velocidad))
	
func golpear(target):
	if target.name.begins_with("Player"):
		target.fuiGolpeado(self)
		get_parent().queue_free()
	else:
		get_parent().queue_free()
