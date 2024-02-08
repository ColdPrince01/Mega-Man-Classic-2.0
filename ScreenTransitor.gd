class_name ScreenTransitor
extends Panel

var target : Node2D
var player = MainInstances.player as Player


#This Scene is intended for detecting when the player has reached the edge of a screen limit, a signal will be emitted to the camera
#alerting it to commense a transition to the next section of the level

@onready var detector = $Detector
@onready var collision_shape_2d = $Detector/CollisionShape2D


@export var current_screen : Panel
@export var new_screen : Panel


func _ready():
	collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.extents = self.size / 2
	collision_shape_2d.position = self.size / 2
	
	

func _process(delta):
	pass
	






func _on_detector_body_entered(body):
	if body is CharacterBody2D:
		Events.change_active.emit(current_screen, new_screen)
