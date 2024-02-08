class_name CameraLimits
extends Panel

@export var init_active := true
@onready var collision_shape_2d = $PlayerDetector/CollisionShape2D
@onready var player_detector = $PlayerDetector

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.extents = self.size / 2
	collision_shape_2d.position = self.size / 2
	if init_active and player_detector.has_overlapping_bodies():
		Events.camera_limits_changed.emit(
			position.x, #left limit
			position.x + size.x, #right limit
			position.y, #top limit
			position.y + size.y, #bottom limit	
			)
	else:
		Events.camera_limits_changed.emit(-10000000, 10000000, -10000000, 10000000)
	








func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		init_active = true


func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		init_active = false
