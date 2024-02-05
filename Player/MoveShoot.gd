extends State

@export var move_state : State
@export var idle_shoot_state : State
@export var jump_shoot_state : State
@export var idle_state : State
@export var stagger_state : State
@export var slide_state : State
@export var jump_state : State

@export var buster_position := Vector2(21, -1)
@export var shoot_time := 0.3 #variable for how long the animation will hold 

var shoot_timer = 0.0

func enter():
	super()
	shoot_timer = shoot_time

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_up") and parent.is_on_floor(): #if jump button pressed and parent is on floor
		return jump_shoot_state
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("slide") and parent.is_on_floor():
			parent.slide_dust_instantiation()
			return slide_state
	return null

func process_physics(delta: float) -> State:
	shoot_timer -= delta
	parent.velocity.y += movement_data.gravity * delta
	
	
	var input_direction = get_movement_input()
	
	if input_direction == 0: #if the player stops moving
		return idle_state #return idle state
		
	
	parent.mega_man_sprite.flip_h = input_direction < 0 #if movement is negative, flip sprite
	parent.velocity.x = input_direction  * movement_data.move_speed
	parent.move_and_slide() #call move and slide after calculating velocity 
	
	if shoot_timer <= 0.0:
		return move_state
	
	if parent.is_damaged:
		return stagger_state
	
	if !parent.is_on_floor() and shoot_timer > 0.0: #if player is in the air 
		return jump_shoot_state
	if !parent.is_on_floor() and shoot_timer <= 0.0:
		return jump_state
	return null #return nothing, if nothing is happening 
