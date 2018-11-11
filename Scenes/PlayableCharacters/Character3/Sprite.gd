extends Sprite

var particlesDer
var particlesIzq

func _ready():

	particlesDer = get_node("ParticlesDer")
	particlesIzq = get_node("ParticlesIzq")
	
func emitir():
	if self.flip_h:
		particlesDer.emitting = true
	else:
		particlesIzq.emitting = true

