extends Area2D

signal detected

func _on_Detector_body_entered(body):
	if body.name == "Player":
		emit_signal("detected")
