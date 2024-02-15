extends Node


@export var galaxy_man_theme : AudioStream
@export var game_over_theme : AudioStream
@export var menu_theme : AudioStream

var current_song

@onready var audio_stream_player = $AudioStreamPlayer

func play(song, from_position = 0.0, volume_db = 0.0):
	audio_stream_player.stream = song
	audio_stream_player.volume_db = volume_db
	audio_stream_player.play(from_position)

#function for fading the music out
func fade(duration = 1.0):
	var previous_volume_db = audio_stream_player.volume_db
	var volume_fade = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN) #creates the properties of the music to be tweened
	volume_fade.tween_property(audio_stream_player, "volume_db", -50.0, duration) #takes the tween of the volume fade variable, and causes it so slowly fade out from its
	#current volume 
	await volume_fade.finished #wait untilt he fade has finished
	audio_stream_player.stop() #then stop the song 
	audio_stream_player.volume_db = previous_volume_db

func stop():
	if audio_stream_player.playing:
		audio_stream_player.stop()
