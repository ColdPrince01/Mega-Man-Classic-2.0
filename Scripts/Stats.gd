class_name Stats
extends Node


@export var max_health = 3 : set = set_max_health #editable variable max_health, at the onset set to three, the setter is function set health
@onready var health = max_health : set = set_health

signal no_health #signal for when the health has reached zero 
signal health_changed
signal max_health_changed

func set_max_health(value):
	max_health = value
	max_health_changed.emit()
	


func set_health(value):
	health = clamp(value, 0, max_health)
	health_changed.emit()
	if health <= 0: no_health.emit()
