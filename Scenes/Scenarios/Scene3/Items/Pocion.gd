extends Area2D

var animacion 

func _ready():
	self.connect("body_entered",self,"sumarVida")
	animacion = get_node("AnimationPlayer")
	animacion.play("Normal")
	
func sumarVida(target):
	if target.name.begins_with("Player"):
		if target.Life.vida < 6:	
			target.Life.vida += 1
			self.queue_free()
		else:
			self.queue_free()


