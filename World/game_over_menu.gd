extends ColorRect

@onready var game_over = $GameOver
@onready var resume = $CenterContainer/VBoxContainer/Continue #changed to resume as a variable because continue usually refers to for loops
@onready var game_over_anim = $GameOverAnim
@onready var continue_anim = $ContinueAnim
@onready var title_anim = $TitleAnim
@onready var quit_anim = $QuitAnim
@onready var title_screen = $CenterContainer/VBoxContainer/TitleScreen
@onready var quit = $CenterContainer/VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	await ScreenTransition.fade_out()
	await get_tree().create_timer(2).timeout
	game_over_anim.play("fade_in")
	Music.play(Music.game_over_theme, 0.0, -12.0)
	await get_tree().create_timer(3).timeout
	game_over_anim.play("fade_out")
	Music.stop()
	await get_tree().create_timer(2).timeout
	Music.play(Music.menu_theme, 0.0, -12.0)
	continue_anim.play("fade_in")
	title_anim.play("fade_in")
	quit_anim.play("fade_in")
	resume.grab_focus()
	title_screen.grab_focus()
	quit.grab_focus()





func _on_quit_pressed():
	get_tree().quit()


func _on_title_screen_pressed():
	Music.stop()
	get_tree().change_scene_to_file("res://UI/title_screen.tscn")


func _on_continue_pressed():
	Music.stop()
	get_tree().change_scene_to_file("res://World/world.tscn")
