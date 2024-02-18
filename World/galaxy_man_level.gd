class_name Level
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_died.connect(end_music)
	await get_tree().create_timer(2.0).timeout
	Music.play(Music.galaxy_man_theme, 0.0, -12.0)


func end_music():
	Music.stop()
