extends Area2D
enum pociones {vida,dash}
export (pociones) var potas
var animacion 
var audioPick 
var collisionShape

func _ready():

	self.connect("body_entered",self,"sumarVida")
	animacion = get_node("AnimationPlayer")
	animacion.play("Normal")
	audioPick = get_node("AudioStreamPlayer2D")
	collisionShape = get_node("CollisionShape2D")

func sumarVida(target):
	if target.name.begins_with("Player") and potas == pociones.vida:
		if target.Life.vida < 6:
			audioPick.play(0)	
			target.Life.vida += 1
			self.visible = false
			self.collisionShape.disabled = true
		else:
			self.queue_free()
	elif target.name.begins_with("Player") and potas == pociones.dash:
		if target.Life.powerUp < 3:
			audioPick.play(0)	
			target.Life.powerUp += 1	
			self.visible = false
			self.collisionShape.disabled = true
		else: 
			queue_free()	
			
func _on_AudioStreamPlayer_finished():
	queue_free()			
	
	


