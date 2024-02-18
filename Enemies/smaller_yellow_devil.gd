extends Node2D

const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var init_dir = DIRECTION.LEFT
@export var speed = 20.0
@export var decel_speed = 435.0

@onready var sprite_2d = $AnimatableBody2D/Sprite2D
@onready var stats = $Stats
@onready var timer = $Timer

var direction : Vector2
var velocity : int
var start_dir

func initialize(pos : Vector2, dir: Vector2, velo: int, start_dir):
	global_position = pos
	direction = dir
	velocity = velo
	init_dir = start_dir
	

func _ready():
	sprite_2d.scale.x = init_dir
	
	

func _physics_process(delta):
	position += direction.normalized() * velocity * delta
	if timer.time_left > 0.0:
		velocity -= decel_speed * delta
	if timer.is_stopped() == true:
		velocity = 0.0


func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	Sounds.play(Sounds.enemy_hurt)



func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionEffectScene, sprite_2d.global_position)
	queue_free()


