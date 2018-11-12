extends Area2D



func _ready():
	self.connect("body_entered",self,"Golpiar")
	
func Golpiar(target):
	target.fuiGolpeado(get_parent())
	

