
class_name Section
extends Node2D

#Area that defines a section of the stage, Triggers a camera transition when player enters 
signal transition_entered(transition)

@export var width := 384
@export var height := 240

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var reference_rect = $ReferenceRect


var limit_left: float
var limit_top: float
var limit_right: float
var limit_bottom: float

#variable for transition direction
var transition_dir: Vector2

var active: bool

func _ready():
	width = reference_rect.size.x
	height = reference_rect.size.y
	limit_left = global_position.x
	limit_top = global_position.y
	limit_right = global_position.x + collision_shape_2d.shape.extents.x * 2
	limit_bottom = global_position.y + collision_shape_2d.shape.extents.y * 2

func update_direction(previous_section : Section):
	transition_dir = Vector2.ZERO
	var is_vertical: bool = true
	
	if limit_left >= previous_section.limit_right or limit_right <= previous_section.limit_left:
		is_vertical = false
		
	if is_vertical:
		if global_position.y > previous_section.global_position.y:
			transition_dir = Vector2.DOWN #if the new section is below the previous section, the transition direction is down
		else:
			transition_dir = Vector2.UP
	else:
		if global_position.x > previous_section.global_position.x:
			transition_dir = Vector2.RIGHT
		else:
			transition_dir = Vector2.LEFT


func get_section_center() -> Vector2:
	return Vector2(limit_left + limit_right / 2, limit_top + limit_bottom / 2)


