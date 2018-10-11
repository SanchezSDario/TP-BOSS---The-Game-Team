extends Camera2D

func _process(delta):
	if(get_parent().has_node("Assasin")):
		position = get_parent().get_node("Assasin").position

