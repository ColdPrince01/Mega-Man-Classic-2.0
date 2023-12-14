extends Node2D


@onready var slide_timer = $SlideTimer

#function for when the player begins their slide
func start_slide(duration = 0.4):
	slide_timer.wait_time = duration
	slide_timer.start()

func is_sliding():
	return !slide_timer.is_stopped()

func not_sliding():
	return slide_timer.is_stopped()
