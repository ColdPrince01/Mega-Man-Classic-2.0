extends CharacterBody2D

const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")

enum DIRECTION_Y {UP = -1, DOWN = 1}
enum DIRECTION_X {LEFT = -1, RIGHT = 1}

@export var init_dir_y =  DIRECTION_Y.UP
@export var init_dir_x = DIRECTION_X.LEFT
@export var flight_speed = 45.0

@onready var grav_timer = $GravTimer
@onready var grav_timer_2 = $GravTimer2
@onready var stats = $Stats

var gravity = 40.0
var active := false

func _ready():
	pass
	

func _physics_process(delta):
	if active:
		velocity.x = (flight_speed * init_dir_x)
		velocity.y = init_dir_y * gravity
	
		
		
	
	
	move_and_slide()
	


func swap_grav():
	init_dir_y *= -1

func _on_visible_on_screen_notifier_2d_screen_exited():
	active = false
	queue_free()




func _on_visible_on_screen_notifier_2d_screen_entered():
	active = true
	grav_timer.start()


func _on_grav_timer_timeout():
	swap_grav()
	


func _on_grav_timer_2_timeout():
	swap_grav()


func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	Sounds.play(Sounds.enemy_hurt)


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position + Vector2(0,-7))
	queue_free()
