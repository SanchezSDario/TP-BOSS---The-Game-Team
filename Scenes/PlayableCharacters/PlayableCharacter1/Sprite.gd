extends Sprite

var assasin
 
func _ready():
	assasin = get_parent()
	pass

func _process(delta):
	match(assasin.state_identifier):
		"Idle": pass 
	pass