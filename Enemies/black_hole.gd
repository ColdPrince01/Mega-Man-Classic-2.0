extends Node2D


@export var grab_velocity_x := 78.0 #amount of velocity for black hole grab
@export var  grab_velocity_y := 210.0
@export var object_speed := 35.0

@onready var active_area = $ActiveArea

func _physics_process(delta):
	var player = MainInstances.player
	if !player == null:
		var player_dir = self.global_position - player.global_position
		if active_area.has_overlapping_areas():
			player.global_position.x += player_dir.normalized().x * grab_velocity_x * delta
		

func find_player(delta):
	pass
