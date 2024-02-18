class_name Bullet
extends Node2D

@export var bullet_speed = 250

var is_reflected := false
var velocity = Vector2.ZERO
var direction : Vector2

@onready var bullet_behavior = $BulletBehavior
@onready var reflect_destroy = $ReflectDestroy
@onready var reflect_animation = $ReflectAnimation
@onready var sprite_2d = $Sprite2D


func initialize(pos : Vector2, dir: Vector2, velo: int):
	global_position = pos
	direction = dir
	velocity = velo
	


func update_velocity():
	velocity.x = bullet_speed 


func _process(delta):
	position += velocity * delta
	

#this doesn't work yet 



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hit_box_component_area_entered(area):
	if area is HurtBox:
		queue_free()


func _on_hit_box_component_body_entered(body):
	pass
