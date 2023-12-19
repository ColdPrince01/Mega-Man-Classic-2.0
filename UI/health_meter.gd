extends Control

@onready var full = $Full
@onready var empty = $Empty

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health_ui() #on ready the game will update the health ui to match max health
	update_max_health_ui() #on ready the game will update the health ui to match the max health value 
	PlayerStats.health_changed.connect(update_health_ui)
	PlayerStats.max_health_changed.connect(update_max_health_ui)

func update_health_ui():
	full.size.y = PlayerStats.health * 2 #takes the texture for the full health sprite and configures it based on player's current health value returned 
	

func update_max_health_ui():
	empty.size.y = PlayerStats.max_health * 2
