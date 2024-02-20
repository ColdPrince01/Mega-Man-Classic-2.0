extends CharacterBody2D

enum DIRECTION {LEFT = -1, RIGHT = 1}

const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")

@export var speed = 65.0
@export var init_direction = DIRECTION.RIGHT

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var stats = $Stats
@onready var hurt_box_shape = $HurtBoxComponent/HurtBoxShape
@onready var hurt_flicker = $HurtFlicker
@onready var collision_shape_2d = $CollisionShape2D
@onready var deflect_collision = $DeflectBox/DeflectCollision
@onready var hit_collision = $HitBoxComponent/HitCollision


var direction = 1.0

func _ready():
	direction = init_direction
	sprite_2d.scale.x = init_direction
	deflect_collision.position.x *= init_direction
	hit_collision.position.x *= init_direction
	collision_shape_2d.position.x *= init_direction
	hurt_box_shape.position.x *= init_direction

func _physics_process(delta):
	
	if is_on_wall():
		turn_around()
	
	velocity.x = speed * direction
	handle_sprites()
	
	move_and_slide()


func handle_sprites():
	sprite_2d.scale.x = direction
	

func turn_around():
	direction *= -1.0
	deflect_collision.position.x *= -1
	hit_collision.position.x *= -1
	collision_shape_2d.position.x *= -1
	hurt_box_shape.position.x *= -1
	

func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position)
	queue_free()


func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	Sounds.play(Sounds.enemy_hurt)
	hurt_flicker.play("blink")



	


func _on_visible_on_screen_notifier_2d_screen_exited():
	set_physics_process(false)


func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)


func _on_deflect_box_hurt(hitbox, damage):
	stats.health -= 0
	Sounds.play(Sounds.enemy_deflect)
