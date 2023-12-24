extends State

@export var idle_state : State
@export var move_state : State

func enter() -> void:
	super()
	parent.velocity.y = 0.0
	

func process_physics(delta : float) -> State:
	parent.velocity.y += movement_data.gravity * delta 
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	
	var movement = Input.get_axis("ui_left", "ui_right") * movement_data.move_speed
	
	if movement != 0:
		parent.mega_man_sprite.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor(): #if parent is on the floor
		if movement !=0:
			return move_state
		return idle_state
	return null
