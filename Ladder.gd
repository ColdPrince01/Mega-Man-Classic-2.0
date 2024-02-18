extends StaticBody2D


const TILE_SIZE := 16

@export var size_in_tiles := 3 

@onready var collision_segment = $LadderArea/CollisionSegment
@onready var ladder_area = $LadderArea
@onready var collision_shape_2d = $CollisionShape2D
@onready var ladder = $"."


@onready var player = get_tree().current_scene.get_node("TestPlayer")

func _physics_process(delta):
	if ladder_area.has_overlapping_areas() and player.is_climbing:
		player.global_position.x = collision_segment.global_position.x
	else:
		return
	
	
	
