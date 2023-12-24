extends State

@export var idle_state: State
@export var move_state: State

func enter() -> void:
	super() #call every line in the enter method in the State Class
	if parent.velocity.y <= 0.0 and parent.is_on_floor():
		parent.velocity.y = -movement_data.jump_velocity #set parent's velocity equal to jump force


func process_input(event: InputEvent) -> State:
	if not parent.is_on_floor():
		if Input.is_action_just_released("ui_up") and parent.velocity.y < 0.0:
			parent.velocity.y = -movement_data.jump_velocity / 10
	return null


#function handles physics process for jumping, will be sent up to the player script and processed under the _physics_process(): function
func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	
	var input_direction = Input.get_axis("ui_left","ui_right")
	
	if input_direction != 0: #if the player is moving
		parent.mega_man_sprite.flip_h = input_direction < 0 #whether or not the player sprite flips is determined by the direction of movement
	parent.velocity.x = input_direction * movement_data.move_speed
	parent.move_and_slide() #call move and slide after movement calculations
	
	
	if parent.is_on_floor(): #if the player is on the floor
		if input_direction != 0: #and they are moving
			return move_state #set state = to move state
		return idle_state #if on the floor and not moving, set state = idle_state
	
	return null #if nothing changes return null 


func exit():
	var exit_velocity = parent.velocity.x
	return exit_velocity


