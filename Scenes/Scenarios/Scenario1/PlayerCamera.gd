extends Camera2D

func _process(delta):
	position = get_parent().get_node("Assasin").position
