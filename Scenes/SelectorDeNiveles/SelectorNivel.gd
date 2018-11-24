extends CanvasLayer

export(PackedScene) var personaje1
export(PackedScene) var personaje2
export(PackedScene) var personaje3
var botonPersonaje1
var botonPersonaje2
var botonPersonaje3
func _ready():
	botonPersonaje1 = get_node("TextureRect/Personaje1")
	botonPersonaje2 = get_node("TextureRect2/Personaje2")
	botonPersonaje3 = get_node("TextureRect3/Personaje3")
	botonPersonaje1.connect("pressed",self,"PonerPersonaje1")
	botonPersonaje2.connect("pressed",self,"PonerPersonaje2")
	botonPersonaje3.connect("pressed",self,"PonerPersonaje3")
	
func PonerPersonaje1():
	
	get_tree().change_scene("res://Scenes/Scenarios/Scene3/Scenario3.tscn")
	
func PonerPersonaje2():
	
	get_tree().change_scene("res://Scenes/Scenarios/Scene3/Scenario3.tscn")
	
func PonerPersonaje3():
	
	get_tree().change_scene("res://Scenes/Scenarios/Scenario1/Scenario1.tscn")


