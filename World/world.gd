extends Node2D

@onready var level_scene: = $GalaxyManLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)

