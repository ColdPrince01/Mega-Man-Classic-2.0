class_name Player
extends CharacterBody2D






@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var dash_timer = $DashTimer
@onready var dash_buffer = $DashBuffer



var dashing = false
var can_dash = true


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

	
	update_animation(input_direction)
	set_direction(input_direction)
	get_direction()
	if Input.is_action_pressed("ui_accept"):
		Engine.time_scale = 0.1
	else: 
		Engine.time_scale = 1.0

	if dashing:
		velocity.x = input_direction * dash_speed
	else:
		velocity.x = input_direction * max_speed
	var was_on_floor = is_on_floor() #variable was_on_floor calls for is_on_floor before move_and_slide is called
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() #just left ledge is the player was on the floor before move and slide but isn't on the floor after
	if just_left_ledge and velocity.y >= 0: #if the player left the ledge and is falling
		coyote_jump_timer.start()


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
	if is_moving(input_direction):
		animation_player.play("run")
	else:
		animation_player.play("idle")
		
	if not is_on_floor():
		animation_player.play("jump")
	
	if dashing:
		animation_player.play("slide")




func _on_dash_timer_timeout():
	dashing = false


func _on_dash_buffer_timeout():
	can_dash = true
