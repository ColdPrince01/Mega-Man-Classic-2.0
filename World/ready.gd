extends CanvasLayer


@onready var ready_text = $Ready
@onready var ready_blink = $ReadyBlink
@onready var timer = $Timer



func _on_timer_timeout():
	hide()
