extends StaticBody2D


const TILE_SIZE := 16

var player = []

@export var size_in_tiles := 3 


@onready var collision_segment = $CollisionSegment
@onready var collision_shape_2d = $CollisionShape2D

