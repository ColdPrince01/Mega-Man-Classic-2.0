extends State

@export var jump_state : State
@export var idle_state : State
@export var stagger_state : State

func enter():
	super()
	parent.velocity.x = 0.0
	parent.velocity.y = 0.0
	


func process_input(input : InputEvent) -> State:
	if Input.is_action_just_pressed("ui_accept"):
		return jump_state
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.climb_speed, movement_data.climb_speed)
	if parent.can_climb:
		if Input.is_action_pressed("ui_up"):
			parent.is_climbing = true
			parent.character_animator.play("climb_move")
			parent.velocity.y = -movement_data.climb_speed
		elif Input.is_action_pressed("ui_down"):
			parent.is_climbing = false
			parent.character_animator.play("climb_move")
			parent.velocity.y = movement_data.climb_speed
			
		else:
			parent.velocity.y = 0.0
			parent.character_animator.play("climb_idle")
			
			
		
		
		
	elif !parent.can_climb and !parent.is_on_floor():
		return jump_state
	elif !parent.can_climb and parent.is_on_floor():
		return idle_state
	elif parent.is_damaged:
		return stagger_state
	
	else:
		return idle_state
		
		
	parent.move_and_slide()
	if parent.is_on_floor():
		return idle_state
	return null


func exit():
	parent.is_climbing = false
	parent.can_climb = false
	parent.character_animator.play("climb_exit")
