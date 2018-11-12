extends Area2D
enum pociones {vida,dash}
export (pociones) var potas
var animacion 
	
func _ready():
	self.connect("body_entered",self,"sumarVida")
	animacion = get_node("AnimationPlayer")
	animacion.play("Normal")

func sumarVida(target):
	if target.name.begins_with("Player") and potas == pociones.vida:
		if target.Life.vida < 6:	
			target.Life.vida += 1
			self.queue_free()
		else:
			self.queue_free()
	elif target.name.begins_with("Player") and potas == pociones.dash:
		if target.Life.powerUp < 3:
			target.Life.powerUp += 1	
			self.queue_free()		
		else: 
			queue_free()	
	
	


