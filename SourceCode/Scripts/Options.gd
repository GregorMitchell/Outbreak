extends Control


func _ready():
	$ControlVideo/resolution.add_item("1024 X 600", 0)
	$ControlVideo/resolution.add_item("1920 X 1080", 1)
	
	if Options.res_width == 1024 and Options.res_height == 600:
		$ControlVideo/resolution.select(0)
	elif Options.res_width == 1920 and Options.res_height == 1080:
		$ControlVideo/resolution.select(0)

	$ControlVideo/fullscreen.add_item("Fullscreen", 0)
	$ControlVideo/fullscreen.add_item("Windowed", 1)
	
	if Options.fullscreen == true:
		$ControlVideo/fullscreen.select(0)
	elif Options.fullscreen == false:
		$ControlVideo/fullscreen.select(1)

	$ControlAudio/master.set_value(Options.master_volume)
	
	
func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")


func _on_resolution_item_selected(id):
	match id:
		0:
			Options.res_width = 1024
			Options.res_height = 600
			Options.resolution()
		1:
			Options.res_width = 1920
			Options.res_height = 1080
			Options.resolution()


func _on_fullscreen_item_selected(id):
	match id:
		0:
			Options.fullscreen = true
			Options.resolution()
		1:
			Options.fullscreen = false
			Options.resolution()


func _on_master_mute_pressed():
	if Options.master_mute == true:
		Options.master_mute = false
	elif Options.master_mute == false:
		Options.master_mute = true
	
	Options.game_music()
	
	
func _on_master_value_changed(value):
	Options.master_volume = $ControlAudio/master.get_value()
