class_name Bullet
extends Node2D

@export var bullet_speed = 250

var is_reflected := false
var velocity = Vector2.ZERO

@onready var bullet_behavior = $BulletBehavior
@onready var reflect_destroy = $ReflectDestroy
@onready var reflect_animation = $ReflectAnimation
@onready var sprite_2d = $Sprite2D




func update_velocity():
	velocity.x = bullet_speed 


func _process(delta):
	position += velocity * delta
	

#this doesn't work yet 
func reflected():
	if is_reflected:
		return
		
		bullet_behavior.bullet_speed = 60.0
		bullet_behavior.bullet_gravity = 400.0
		bullet_behavior.angle_in_degrees = randf_range(230, 310)
		
		reflect_animation.play("reflected")
		reflect_destroy.start()
		
		is_reflected = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hit_box_component_area_entered(area):
	queue_free()


func _on_hit_box_component_body_entered(body):
	pass
