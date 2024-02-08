extends Camera2D

#Node for panning the camera between sections

@export var player: CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = player.position
	var x = floor(position.x / 320) * 320
	var y = floor(position.y / 180) * 180
	position = Vector2(x , y)
