class_name Blaster
extends Node2D


const LemonScene = preload("res://OtherScenes/PlayerLemon.tscn")

@onready var shoot_pos = $ShootPos


var parent = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func fire_bullet():
	var bullet = Utils.instantiate_scene_on_world(LemonScene, shoot_pos.global_position)
	print("lemon launched")
