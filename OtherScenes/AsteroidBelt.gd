extends ParallaxLayer


@export var asteroid_speed := -15.0


func _process(delta):
	self.motion_offset.x += asteroid_speed * delta
