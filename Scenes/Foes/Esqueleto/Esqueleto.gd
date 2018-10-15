extends KinematicBody2D
var rayAtaqueIzq
var rayAtaqueDer
var CharacterController
var AnimationController
var collisionShape
var seguidorDer
var seguidorIzq
var collision
var voyAtacar = false
var estoyAtacando = false
func _ready():
	set_meta("Type" ,"Enemy")
	rayAtaqueIzq = get_node("rayAtaqueIzq")
	rayAtaqueDer = get_node("rayAtaqueDer")
	seguidorDer = get_node("SeguidorDer")
	seguidorIzq = get_node("SeguidorIzq")
	CharacterController = get_node("CharacterController")
	AnimationController = get_node("SpriteAnimatedController")
	collisionShape = get_node("CollisionShape2D")



func _process(delta):
	AnimationController.Normal()
	SeguirDer()
	SeguirIzq()
	CharacterController.Gravedad()
	Atacar(rayAtaqueDer)
	Atacar(rayAtaqueIzq)

func SeguirDer():
	if seguidorDer.is_colliding() and seguidorDer.get_collider().get_meta("Type") == "Player" and !voyAtacar:
		collision = CharacterController.Movimiento(1)
		AnimationController.CaminandoDerecha()
		AnimationController.flipContrario()
		
func SeguirIzq():
	if seguidorIzq.is_colliding() and seguidorIzq.get_collider().get_meta("Type") == "Player" and !voyAtacar:
		collision = CharacterController.Movimiento(-1)
		AnimationController.CaminandoIzquierda()
		AnimationController.flipContrario()


func Atacar(ray):
	if ray.is_colliding() and ray.get_collider().get_meta("Type") == "Player" and !estoyAtacando:
		ray.enabled = false
		Ataque(ray)
		AnimationController.Ataque()

func golpie(ray):
	if ray.is_colliding() and ray.get_collider().get_meta("Type") == "Player":
		ray.get_collider().recibiGolpe()
		
		
func Ataque(ray):
	voyAtacar = true
	estoyAtacando = true
	ray.enabled = true
	yield(get_tree().create_timer(1),"timeout")
	golpie(ray)
	yield(get_tree().create_timer(0.4),"timeout")
	estoyAtacando = false
	voyAtacar = false		