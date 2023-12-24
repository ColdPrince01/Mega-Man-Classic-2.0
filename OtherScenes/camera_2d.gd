extends Camera2D

var shake = 0

@onready var screen_shake = $ScreenShake


func _ready():
	Events.add_screenshake.connect(set_screenshake)
	Events.camera_limits_changed.connect(update_limits)


func _process(delta):
	offset.x = randf_range(-shake, shake)
	offset.y = randf_range(-shake, shake)

func update_limits(left, right, top, bottom):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom
	print("limits updated")

func set_screenshake(magnitude, duration):
	shake = magnitude #shake strength is equal to magnitude passed in 
	screen_shake.wait_time = duration #screen shake time is equal to magnitude passed in
	screen_shake.start()


func _on_screen_shake_timeout():
	shake = 0
