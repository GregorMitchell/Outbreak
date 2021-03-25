extends Area2D

onready var sprite = get_node("Sprite")
signal collected

func _ready():
	sprite.play("Normal")


func _on_Collectible_body_entered(body):
	if body.name == "Player":
		emit_signal('collected')
		queue_free()
