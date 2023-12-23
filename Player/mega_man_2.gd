extends CharacterBody2D


@onready var mega_man_sprite = $MegaManSprite



@export var acceleration = 512
@export var walk_speed = 82.5
@export var friction = 256
@export var gravity = 980
@export var jump_force = 225
@export var max_fall_speed = 485
@export var wall_slide_speed = 42
@export var max_wall_slide_speed = 128
@export var gravity_multiplier = 1.0
@export var dash_speed = 160
@export var knockback_distance = 50.0


func _physics_process(delta):
	var input_direction = Input.get_axis("ui_left","ui_right")
	set_direction(input_direction)
	get_direction()
	handle_gravity(delta)
	horizontal_movement(input_direction)
	
	move_and_slide()


func set_direction(input_direction):
	if Vector2.RIGHT and input_direction > 0: #if the vector2 returns that the player is moving right
		mega_man_sprite.flip_h = false
	if Vector2.LEFT and input_direction < 0: #if the player is moving left
		mega_man_sprite.flip_h = true

func get_direction():
	return Vector2.LEFT if mega_man_sprite.flip_h else Vector2.RIGHT

func handle_gravity(delta):
	if is_on_floor(): return
	velocity.y += gravity * gravity_multiplier * delta
	velocity.y = clamp(velocity.y, 0, max_fall_speed)
	

func is_moving(input_direction):
	return input_direction != 0
	
	
func horizontal_movement(input_direction):
	if is_moving(input_direction):
		velocity.x = input_direction * walk_speed


func handle_animations():
	pass
