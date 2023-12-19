extends ColorRect


@onready var start_blink = $Node/StartBlink
@onready var quit_blink = $Node/QuitBlink
@onready var big_mega_man_2 = $Node/BigMegaMan2
@onready var title_screen_2 = $Node/TitleScreen2
@onready var label = $Node/Label
@onready var bg_effects = $BGEffects

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	await get_tree().create_timer(2).timeout
	label.play("fade_in")
	await label.animation_finished
	title_screen_2.play("tween_in")
	await title_screen_2.animation_finished
	title_screen_2.play("blink")
	await title_screen_2.animation_finished
	big_mega_man_2.play("fade_in")
	await big_mega_man_2.animation_finished
	start_blink.play("fade_in")
	quit_blink.play("fade_in")
	await quit_blink.animation_finished
	bg_effects.set_emitting(true)


func _process(delta):
	pass

func _on_start_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
