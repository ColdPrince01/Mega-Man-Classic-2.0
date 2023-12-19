extends Camera2D

var shake = 0

@onready var screen_shake = $ScreenShake


func _ready():
	Events.add_screenshake.connect(set_screenshake)


func _process(delta):
	offset.x = randf_range(-shake, shake)
	offset.y = randf_range(-shake, shake)

func set_screenshake(magnitude, duration):
	shake = magnitude #shake strength is equal to magnitude passed in 
	screen_shake.wait_time = duration #screen shake time is equal to magnitude passed in
	screen_shake.start()


func _on_screen_shake_timeout():
	shake = 0
