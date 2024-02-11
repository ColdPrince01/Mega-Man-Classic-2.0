class_name Parallax_Scrolling
extends ParallaxLayer

@export var star_speed := -15.0


func _process(delta):
	self.motion_offset.x += star_speed * delta
