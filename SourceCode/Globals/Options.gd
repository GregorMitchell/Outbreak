extends Control
#globals
var play_music = 1
var master_volume = 1
var music_volume = 1
var master_mute = false
var new_choice = 1
var song
var res_width = 1024
var res_height = 600
var fullscreen = false

func _ready():
	game_music()
	resolution()

func _process(delta):
	if master_mute == false:
		if ! $Music.is_playing():
			game_music()
		
		if master_volume > -80 and music_volume > -80:
			play_music = 1
		
		$Music.set_volume_db(master_volume)
	elif master_mute == true:
		$Music.stop()
	
func game_music():
	song = load("res://Assets/GameMusic.wav")
	$Music.set_stream(song)
	$Music.play(0.0)

	
func resolution():
	ProjectSettings.set_setting("display/window/size/width", res_width)
	ProjectSettings.set_setting("display/window/size/height", res_height)
	OS.set_window_size(Vector2(res_width, res_height))
	
	if fullscreen == true:
		OS.set_window_fullscreen(false)
		OS.set_window_fullscreen(true)
	elif fullscreen == false:
		OS.set_window_fullscreen(true)
		OS.set_window_fullscreen(false)
		OS.set_window_position(Vector2(0,0))
