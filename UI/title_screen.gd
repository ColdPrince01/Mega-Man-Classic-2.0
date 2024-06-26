extends ColorRect


@onready var start_blink = $Node/StartBlink
@onready var quit_blink = $Node/QuitBlink
@onready var big_mega_man_2 = $Node/BigMegaMan2
@onready var title_screen_2 = $Node/TitleScreen2
@onready var label = $Node/Label
@onready var bg_effects = $BGEffects
@onready var v_box_container = $Buttons/VBoxContainer
@onready var start = $Buttons/VBoxContainer/Start
@onready var quit = $Buttons/VBoxContainer/Quit

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	await ScreenTransition.fade_out()
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
	quit.grab_focus()
	start.grab_focus()


func _process(delta):
	pass

func _on_start_pressed():
	big_mega_man_2.play("tween_out")
	await big_mega_man_2.animation_finished
	await ScreenTransition.fade_in()
	get_tree().change_scene_to_file("res://World/world.tscn")
	

func _on_quit_pressed():
	quit_blink.play("blink")
	await quit_blink.animation_finished
	get_tree().quit()






