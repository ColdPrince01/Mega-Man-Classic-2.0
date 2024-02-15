extends Node2D

var lifetime := -1.0
var direction: Vector2
var velocity: int

@onready var timer = $Timer

func initialize(pos : Vector2, dir: Vector2, velo: int):
	global_position = pos
	direction = dir
	velocity = velo
	

func _ready():
	Sounds.play(Sounds.death_sound, 1.0, -7.0)
	if lifetime > 0:
		timer.start(lifetime)

func _physics_process(delta):
	position += direction.normalized() * velocity * delta


func set_lifetime(length):
	lifetime = length


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
