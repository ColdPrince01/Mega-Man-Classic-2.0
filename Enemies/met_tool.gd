extends Node2D

const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")
const EnemyBullet = preload("res://OtherScenes/enemy_bullet.tscn")

enum DIRECTION {LEFT =-1, RIGHT = 1}

@export var facing_direction = DIRECTION.RIGHT

@onready var sprite_2d = $Sprite2D
@onready var player_finder = $PlayerFinder
@onready var state_timer = $StateTimer
@onready var marker_2d = $Marker2D
@onready var anim_timer = $AnimTimer
@onready var animation_player = $AnimationPlayer
@onready var stats = $Stats


var spawn_pos : Vector2

func _ready():
	player_finder.target_position.x *= facing_direction
	sprite_2d.scale.x = facing_direction
	marker_2d.position.x = abs(marker_2d.position.x) * sign(facing_direction)
	

func _physics_process(delta):
	handle_anims()
	if player_finder.is_colliding():
		anim_timer.start()
		if state_timer.time_left <= 0.0:
			spawn_bullets(marker_2d.global_position)




func handle_anims():
	if anim_timer.time_left > 0.0:
		animation_player.play("open")
	elif anim_timer.time_left <= 0.0:
		animation_player.play("closed")


func spawn_bullets(spawn_pos):
	var bullet : Node2D
	var world = get_tree().current_scene
	for particle in range(3):
		bullet = EnemyBullet.instantiate()
		if facing_direction == DIRECTION.RIGHT:
			bullet.initialize(spawn_pos, Vector2(1,-0.5).rotated(particle * PI/6), bullet.bullet_speed)
		elif facing_direction == DIRECTION.LEFT:
			bullet.initialize(spawn_pos, Vector2(-1,0.5).rotated(particle * PI/6), bullet.bullet_speed)
		world.add_child.call_deferred(bullet)
	state_timer.start()
	


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position + Vector2(0,-7))
	queue_free()



func _on_hurt_box_component_hurt(hitbox, damage):
	if anim_timer.time_left > 0.0: #if the mettool is open, take no damage
		stats.health -= damage
		Sounds.play(Sounds.enemy_hurt)
	elif anim_timer.time_left <= 0.0:
		stats.health -= 0
		Sounds.play(Sounds.enemy_deflect)
