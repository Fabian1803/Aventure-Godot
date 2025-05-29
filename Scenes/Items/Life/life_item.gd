extends Area3D

@export var cantidad_curacion: int = 1
@export var velocidad_rotacion: float = 1.0
@export var altura_levitar: float = 0.3
@export var velocidad_levitar: float = 1.0
@export var gravedad: float = -30.0

@export var offset_piso: float = 1.5  # Altura desde el centro hasta la base del mesh/collider

var tiempo: float = 0.0
var velocidad_y: float = 0.0
var suelo_y: float = 0.0
var cayendo: bool = true

@onready var visual = $heart

func _ready():
	suelo_y = 0  # Ajusta según la altura del suelo en tu mundo
	connect("body_entered", _on_body_entered)

func _process(delta):
	if cayendo:
		velocidad_y += gravedad * delta
		position.y += velocidad_y * delta

		if position.y <= suelo_y + offset_piso:
			position.y = suelo_y + offset_piso
			velocidad_y = 0
			cayendo = false
			tiempo = 0  # reset para levitar

	else:
		# Levitar visualmente
		tiempo += delta
		visual.transform.origin.y = altura_levitar * sin(tiempo * velocidad_levitar)

	# Rotar visual
	visual.rotate_y(velocidad_rotacion * delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.curar(cantidad_curacion)
		queue_free()
