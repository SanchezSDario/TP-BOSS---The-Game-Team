extends Area2D

var posYInicial

func _ready():
	posYInicial = self.position.y
	self.position.y -= 1000
	self.connect("body_entered",self,"Golpiar")
	
func Golpiar(target):
	if target.name.begins_with("Player"):
		target.fuiGolpeado(get_parent())
		
	

