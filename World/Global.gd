extends Node


@onready var player_camera = MainInstances.camera
@onready var player = MainInstances.player

var room_pause := false
@export var room_pause_time := 0.2

func change_room(room_position: Vector2, room_size: Vector2):
	player_camera.current_room_center = room_position
	player_camera.current_room_size = room_size
	
	room_pause = true
	await(get_tree().create_timer(room_pause_time).timeout)
	room_pause = false
