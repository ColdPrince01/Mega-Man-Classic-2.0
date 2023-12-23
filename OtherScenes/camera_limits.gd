extends Panel

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.camera_limits_changed.emit(
		position.x, #left limit
		position.x + size.x, #right limit
		position.y, #top limit
		position.y + size.y, #bottom limit
		
	)
