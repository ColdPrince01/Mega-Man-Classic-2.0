class_name PlayerBehavior
extends Node

#Script for (ideally) trying to condense player behavior code into a single node scene which can then be attached to any CharacterBody2D

signal landed
signal jumped
signal fell_into_pit
signal collision_occured


@export var grav_velocity = 980.0
@export var walk_speed = 250 #px/sec
@export var jump_height = 360
@export var max_fall_speed = 360

@export var floor_normal = Vector2(0, -1) #the floor is below the player, facing up

var velocity = Vector2() #preset variable for player's velocity
var on_air_time : float = 0 #variable for determining time spent in air
var jumping = false
var midair_jump_left = 0
var prev_jump_pressed = false
var just_landed = true
var hit_ceiling
var hit_wall


func _ready():
	pass
	

func _physics_process(delta):
	pass
	

func apply_gravity(delta):
	velocity.y += grav_velocity * delta
