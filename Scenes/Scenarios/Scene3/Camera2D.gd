extends Camera2D

var shake_amount = 5
var timer
var moverCamara = false
var offsetX 
var offsetY
func _ready():
	offsetX = offset.x
	offsetY = offset.y
	timer = Timer.new()
	timer.wait_time = 0.6
	add_child(timer)
	timer.connect("timeout",self,"dejarDeMover")
	

func _process(delta):
	if moverCamara:
		offset = (Vector2( offset.x +
        rand_range(-1.0, 1.0) * shake_amount, \
        offset.y +
        rand_range(-1.0, 1.0) * shake_amount
		
    	))
func _on_Player_hit():
	moverCamara = true
	timer.start()


func dejarDeMover():
	moverCamara = false
	offset.x = offsetX
	offset.y = offsetY
	