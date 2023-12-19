extends CharacterBody2D


const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")

@export var speed = 30.0
@export var gravity = 980.0

var direction = 1.0
var is_invincible = false

@onready var sprite_2d = $Sprite2D
@onready var floor_cast = $FloorCast
@onready var stats = $Stats



func _ready():
	stats.no_health.connect(death)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		if is_on_wall():
			turn_around()
	
	if not floor_cast.is_colliding():
		turn_around()
	velocity.x = direction * speed
	sprite_2d.scale.x = direction

	move_and_slide()


func turn_around():
	direction *= -1


func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	Sounds.play(Sounds.enemy_hurt)


func death():
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position + Vector2(0,-7))
	queue_free()
