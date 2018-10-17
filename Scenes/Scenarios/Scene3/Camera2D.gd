extends Camera2D

var shake_amount = 5
var timer
var moverCamara = false
func _ready():
	timer = Timer.new()
	timer.wait_time = 0.8
	add_child(timer)
	timer.connect("timeout",self,"dejarDeMover")
	

func _process(delta):
	if moverCamara:
		offset = (Vector2( offset.x +
        rand_range(-1.0, 1.0) * shake_amount, \
        -200 
    	))
func _on_Player_hit():
	moverCamara = true
	timer.start()


func dejarDeMover():
	moverCamara = false
	