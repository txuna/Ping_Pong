extends Area2D

export(int) var SPEED = 800

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(_velocity, _global_position):
	velocity = _velocity
	global_position = _global_position
	

func _process(delta):
	global_position += velocity * SPEED * delta
