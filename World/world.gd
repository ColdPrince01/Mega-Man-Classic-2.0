class_name World
extends Node2D

@onready var level_scene: = $GalaxyManLevel



# Called when the node enters the scene tree for the first time.
func _enter_tree():
	MainInstances.world = self

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	await ScreenTransition.fade_out()
	Events.player_died.connect(game_over)
 

func game_over():
	await get_tree().create_timer(6.0).timeout
	await ScreenTransition.fade_in()
	get_tree().change_scene_to_file("res://World/game_over_menu.tscn")

func _exit_tree():
	MainInstances.world = null
