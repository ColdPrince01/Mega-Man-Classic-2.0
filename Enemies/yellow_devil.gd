class_name Devil
extends Node2D


const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")
const SmallDevilScene = preload("res://Enemies/smaller_yellow_devil.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var init_dir = DIRECTION.RIGHT
@export var eject_speed = 290.0

@onready var stats = $Stats
@onready var hurt_flicker = $HurtFlicker
@onready var sprite_2d = $AnimatableBody2D/Sprite2D
@onready var animatable_body_2d = $AnimatableBody2D

func _ready():
	sprite_2d.scale.x = init_dir


func _on_hurt_box_component_hurt(hitbox, damage):
	hurt_flicker.play("blink")
	stats.health -= damage
	Sounds.play(Sounds.enemy_hurt)
	
	

func spawn_devils(spawn_pos):
	var devils : Node2D
	var world = get_tree().current_scene
	for devil in range(4):
		devils = SmallDevilScene.instantiate()
		if init_dir == DIRECTION.RIGHT:
			devils.initialize(spawn_pos, Vector2(1,-0.75).rotated(devil * PI/12), eject_speed, DIRECTION.RIGHT)
		if init_dir == DIRECTION.LEFT:
			devils.initialize(spawn_pos, Vector2(-1,0).rotated(devil * PI/12), eject_speed, DIRECTION.LEFT)
		world.add_child.call_deferred(devils)


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionEffectScene, sprite_2d.global_position)
	spawn_devils(animatable_body_2d.global_position)
	queue_free()
