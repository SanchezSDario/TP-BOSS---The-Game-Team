extends Node

func _ready():
	var scene_instance = GameManager.personajeActual
	if scene_instance == null:
		scene_instance = load("res://Scenes/PlayableCharacters/Character3/Personaje.tscn")
		pass
	scene_instance = scene_instance.instance()
	scene_instance.set_name("Player")
	add_child(scene_instance)
	scene_instance.position = Vector2(0,240)