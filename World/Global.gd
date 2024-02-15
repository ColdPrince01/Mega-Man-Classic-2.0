extends Node


@onready var player_camera = get_tree().current_scene.get_node("Camera2D")
@onready var player = get_tree().current_scene.get_node("TestPlayer")
@onready var world = MainInstances.world

var player_ready := false : set = is_player_ready
var room_pause := false
@export var room_pause_time := 0.2



func change_room(room_position: Vector2, room_size: Vector2):
	if player != null:
		player_camera.current_room_center = room_position
		player_camera.current_room_size = room_size
	else:
		pass
	
	room_pause = true
	await(get_tree().create_timer(room_pause_time).timeout)
	room_pause = false

func is_player_ready(value):
	player_ready = value
