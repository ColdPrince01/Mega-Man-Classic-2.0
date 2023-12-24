extends State
class_name MoveState

@export var idle_state : State
@export var jump_state : State
@export var slide_state : State 


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ui_up") and parent.is_on_floor(): #if jump button pressed and parent is on floor
		return jump_state
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("slide") and parent.is_on_floor():
			return slide_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	
	
	var input_direction = get_movement_input()
	
	if input_direction == 0: #if the player stops moving
		return idle_state #return idle state
		
	
	parent.mega_man_sprite.flip_h = input_direction < 0 #if movement is negative, flip sprite
	parent.velocity.x = input_direction  * movement_data.move_speed
	parent.move_and_slide() #call move and slide after calculating velocity 
	
	if !parent.is_on_floor(): #if player is in the air 
		return jump_state
	return null #return nothing, if nothing is happening 
