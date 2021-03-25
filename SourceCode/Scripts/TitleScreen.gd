extends Control

func _ready():
	pass


func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")


func _on_Exit_pressed():
	get_tree().quit()
