extends State


@export var jump_state: State
@export var move_state: State
@export var slide_state: State

var input_direction = Input.get_axis("ui_left", "ui_right")


func enter() -> void:
	super() #call everything in parent state 
	parent.velocity.x = 0
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_up") and parent.is_on_floor():
		return jump_state #return jump state if jump key is pressed and is on ground
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		return move_state #return move state is left or right key is pressed
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("slide") and parent.is_on_floor():
			return slide_state
	return null #return nothing if no input is recieved
	

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta #at every physics step apply gravity
	parent.move_and_slide() #call move_and_slide after

	if !parent.is_on_floor() and parent.velocity.y > 0.0: #if parent is not on floor and is falling
		return jump_state #return fall state
	return null #otherwise if nothing is happening return nothing and stay idle 
