extends KinematicBody2D


export (int) var speed
export (float) var lifetime

var velocity = Vector2()

func _ready():
	$Lifetime.wait_time = lifetime
	$Lifetime.start()

func start(_position, _direction):
	global_position = _position
	global_rotation = _direction.angle()
	set_rotation_degrees(get_rotation_degrees() + 180)
	velocity = _direction * speed
	
func _process(delta):
	position += -velocity * delta


func _on_Lifetime_timeout():
	queue_free()

