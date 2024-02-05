extends Node

#scene for holding audiostream players, currently holds [12] audio channels all configured to the sounds bus 
#Set as singleton to be accessed globally throughout the project
var sounds_path = "res://Music and Sounds/"

@export var death : AudioStream
@export var enemy_bullet : AudioStream
@export var enemy_deflect : AudioStream
@export var enemy_hurt : AudioStream
@export var hurt : AudioStream
@export var land : AudioStream
@export var lemon_bullet : AudioStream
@export var menu_focus : AudioStream
@export var pause: AudioStream



@onready var sound_players = get_children() #variable for getting the audio players in the scene 

func play(sound_stream, pitch_scale = 1.0, volume_db = 0.0):
	for sound_player in sound_players: #for loop for obtaining child nodes in the Sound Scene
		if not sound_player.playing: #if there is no sound playing
			sound_player.pitch_scale = pitch_scale #set pitch scale equal to pitch scale passed in (default is 1.0)
			sound_player.volume_db = volume_db #set volume equal to volume level passed in (default is 0.0)
			sound_player.stream = sound_stream #load the corresponding sound file with the string passed in (ex. "res://Sounds/bullet.wav")
			sound_player.play() #play the sound 
			return
