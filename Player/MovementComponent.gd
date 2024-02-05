extends Node


#return desired direction of movement for the character
#in the range of [-1,1] 1 is indicative of right, and -1 is indicative of left 
func get_movement_direction() -> float:
	return Input.get_axis("ui_left", "ui_right")
