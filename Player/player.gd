class_name Player
extends CharacterBody2D




const LemonScene = preload("res://Player/lemon.tscn")
const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Mega1
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var dash_timer = $Timers/DashTimer
@onready var dash_buffer = $Timers/DashBuffer
@onready var collision_shape_2d = $CollisionShape2D
@onready var mega_pos = $MegaPos
@onready var bullet_buffer = $Timers/BulletBuffer
@onready var buster_position = Vector2(16,-13)
@onready var fire_rate = $Timers/FireRate
@onready var floor_cast = $FloorCast
@onready var camera_2d = $Camera2D
@onready var blinking_animation_player = $BlinkingAnimationPlayer
@onready var hurt_box_component = $HurtBoxComponent








var dashing = false #variable for when the player is dashing
var can_dash = true #variable for checking when the player can dash 
var is_firing = false #variable for when the player is firing 
var damaged = false #variable for when the player is damaged and is experiencing knockback 
var just_landed = false 

#Values are given as px/seconds (ex. Max_speed is equal to 82.5px/sec 
@export var acceleration = 512
@export var max_speed = 82.5
@export var friction = 256
@export var gravity = 980
@export var jump_force = 225
@export var max_fall_speed = 485
@export var wall_slide_speed = 42
@export var max_wall_slide_speed = 128
@export var gravity_multiplier = 1.0
@export var dash_speed = 160
@export var knockback_distance = 50.0

func _ready():
	PlayerStats.no_health.connect(death) #connect to death when the player dies 

func _physics_process(delta):
	var input_direction = Input.get_axis("ui_left","ui_right")
	handle_gravity(delta)
	
	if is_moving(input_direction):
		apply_horizontal_force(delta, input_direction)
	else:
		apply_friction(delta, input_direction)
	jump_check()
	
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("slide") and is_on_floor() and can_dash:
			dashing = true
			can_dash = false
			dash_timer.start()
			dash_buffer.start()

	land_sound()
	if Input.is_action_just_pressed("Fire") and fire_rate.time_left == 0:
		fire_bullet(delta)
		fire_rate.start()
		bullet_buffer.start()
		is_firing = true
		
	set_direction(input_direction)
	get_direction()
	if Input.is_action_pressed("ui_accept"):
		Engine.time_scale = 0.1
	else: 
		Engine.time_scale = 1.0
	var direction = get_direction().x
	if dashing:
		velocity.y = 0.0
		velocity.x = sign(direction) * dash_speed
	else:
		velocity.x = input_direction * max_speed
		

	update_animation(input_direction)
	var was_on_floor = is_on_floor() #variable was_on_floor calls for is_on_floor before move_and_slide is called
	move_and_slide()
	set_marker_pos()
	if not floor_cast.is_colliding():
		dashing = false
	var just_left_ledge = was_on_floor and not is_on_floor() #just left ledge is the player was on the floor before move and slide but isn't on the floor after
	if just_left_ledge and velocity.y >= 0: #if the player left the ledge and is falling
		coyote_jump_timer.start()


func set_marker_pos():
	if is_on_floor():
		mega_pos.position = buster_position
	

#function for setting player direction
func set_direction(input_direction):
	if Vector2.RIGHT and input_direction > 0: #if the vector2 returns that the player is moving right
		sprite_2d.flip_h = false
	if Vector2.LEFT and input_direction < 0: #if the player is moving left
		sprite_2d.flip_h = true

#function for getting player direction, returns a Vector 2 Value 
func get_direction():
	return Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT


func is_moving(input_direction):
	return input_direction !=0 
	

func handle_gravity(delta):
	if not is_on_floor(): #If the player is not on the floor 
		velocity.y += gravity * gravity_multiplier * delta


func jump_check():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0: #if the player is on the floor or coyote timer has time left
		if Input.is_action_just_pressed("ui_up"):
			mega_pos.position.y -= 7
			velocity.y -= jump_force
	if not is_on_floor():
		if Input.is_action_just_released("ui_up") and velocity.y < 0.0: #if the player releases the jump button while they are moving up
			velocity.y = -jump_force / 10 # they will begin to fall 

func apply_horizontal_force(delta, input_direction):
	if is_moving(input_direction) and is_on_floor(): #if the player is moving 
		velocity.x = move_toward(velocity.x, input_direction * max_speed, acceleration * delta) #move the velocity on the x coordinate from its acceleration to its top speed  
	elif not is_on_floor():
		velocity.x = input_direction * max_speed
func apply_friction(delta, input_direction):
	if not is_moving(input_direction):
		velocity.x = 0


func update_animation(input_direction):
	if hurt_box_component.is_invincible == true: return
	if is_moving(input_direction) and is_on_floor():
		if is_firing:
			animation_player.play("shoot_run")
		else: 
			animation_player.play("run")
			
	else:
		animation_player.play("idle")
		
	if not is_on_floor():
		animation_player.play("jump")
	
	if is_firing and bullet_buffer.time_left > 0.0:
		if is_on_floor():
			if not is_moving(input_direction):
				animation_player.play("shoot")
		
		else:
			animation_player.play("jump_shoot")
	
	if dashing:
		animation_player.play("slide")
	

func land_sound():
	if is_on_floor():
		if just_landed == false:
			Sounds.play(Sounds.land)
			just_landed = true
	elif just_landed:
		just_landed = false

func fire_bullet(delta):
	if dashing or damaged: return
	Sounds.play(Sounds.lemon_bullet)
	mega_pos.position.x = abs(mega_pos.position.x) * get_direction().x #marker 2d node's x position will be set equal to the absolute value of its position relative to its origin * the direction of the player
	var direction = mega_pos.position.x
	var bullet = Utils.instantiate_scene_on_world(LemonScene, mega_pos.global_position)
	bullet.update_velocity()
	bullet.velocity.x = sign(direction) * bullet.speed
	print(bullet.velocity.x)


func _on_dash_timer_timeout():
	dashing = false



func _on_dash_buffer_timeout():
	can_dash = true


func _on_bullet_buffer_timeout():
	is_firing = false

#function for when the player dies
func death():
	camera_2d.reparent(get_tree().current_scene)
	Events.add_screenshake.emit(4, 0.3)
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position)
	queue_free()

func _on_hurt_box_component_hurt(hitbox, damage):
	damaged = true
	Sounds.play(Sounds.hurt)
	Events.add_screenshake.emit(3,0.25)
	PlayerStats.health -= damage
	hurt_box_component.is_invincible = true
	animation_player.play("hurt")
	blinking_animation_player.play("hurt_blink")
	await blinking_animation_player.animation_finished
	hurt_box_component.is_invincible = false 
	damaged = false

