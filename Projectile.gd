class_name Projectile
extends Node2D


@export var speed = 250 


var velocity = Vector2.ZERO

func update_velocity():
	velocity.x = speed
	


func _ready():
	pass
	

func _process(delta):
	position += velocity * delta #updates bullet position every process frame
	



func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() #once the node has left the screen, delete



func _on_hit_box_component_area_entered(area):
	queue_free()


func _on_hit_box_component_body_entered(body):
	queue_free()
