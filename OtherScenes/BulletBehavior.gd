class_name BulletBehavior
extends Node

#Script made for the purpose of holding values and data for any bullet node its attached to 


var parent
var init_position := Vector2() #variable for grabbing parent's global position 
var velocity := Vector2.ZERO
var vec_angle : Vector2

@export var bullet_gravity = 0.0
@export var bullet_acceleration = 0.0
@export var bullet_speed = 120.0
@export var screen_limit = 3
@export var angle_in_degrees = 0.0


func _process(delta):
	do_process(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func do_process(delta: float):
	
	#normalized vector angle for reflect
	vec_angle = Vector2(cos(deg_to_rad(angle_in_degrees)), sin(deg_to_rad(angle_in_degrees)))
	
