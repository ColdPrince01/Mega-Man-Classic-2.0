extends CharacterBody2D




# Get the gravity from the project settings to be synced with RigidBody nodes.


@export var acceleration = 512
@export var max_speed = 64
@export var friction = 256
@export var gravity = 200
@export var jump_force = 128
@export var max_fall_speed = 128
@export var wall_slide_speed = 42
@export var max_wall_slide_speed = 128

func _physics_process(delta):
	var input_direction = Input.get_axis("ui_right","ui_left")
	handle_gravity(delta)
	
	move_and_slide()

func is_moving(input_direction):
	return input_direction !=0

func handle_gravity(delta):
	if not is_on_floor(): #If the player is not on the floor 
		velocity.y =  move_toward(velocity.y, max_fall_speed, gravity * delta) #change the player's gravity overtime (apply gravity)

func jump(height):
	pass
	

func apply_horizontal_force(delta, input_direction):
	pass
	
func update_animation(input_direction):
	pass
	
