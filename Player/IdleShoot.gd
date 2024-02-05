extends State


@export var idle_state : State
@export var move_shoot_state : State
@export var stagger_state : State

@export var shoot_time := 0.3 #variable for how long the animation will hold 
@export var buster_position := Vector2(21, -1) #buster position stored in 

var shoot_timer = 0.0

func enter() -> void:
	super() #call everything in parent state 
	parent.velocity.x = 0
	shoot_timer = shoot_time
	

func process_input(event : InputEvent) -> State:
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		if shoot_timer > 0.0:
			return move_shoot_state
	return null


func process_physics(delta: float) -> State:
	shoot_timer -= delta #shoot time will decrease every physics step (approx. one second every 60 frames)
	parent.velocity.y += movement_data.gravity * delta #at every physics step apply gravity
	parent.move_and_slide() #call move_and_slide after
	
	if parent.is_damaged:
		return stagger_state
		
	if shoot_timer <= 0.0:
		return idle_state
	
	if parent.is_damaged:
		return stagger_state
	
	return null
	


func exit() -> void:
	shoot_timer = 0.0
