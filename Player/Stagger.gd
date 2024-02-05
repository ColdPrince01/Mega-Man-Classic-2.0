extends State


const KNOCKBACK_VELOCITY := 25.0

@export var knockback_timer := 0.2
@export var idle_state : State
@export var move_state : State 
@export var jump_state : State 

var velocity: Vector2

func enter() -> void:
	super()
	parent.damage_flash.play("invincibility")
	print("damage begin")

func process_physics(delta: float) -> State:
	parent.velocity.x = -parent.get_direction().x * KNOCKBACK_VELOCITY
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	parent.move_and_slide()
		
	if !parent.is_damaged and parent.is_on_floor(): #if parent is not damaged any longer, and is on floor
		if get_movement_input() !=0: #if they return input left or right 
			return move_state #send them to move state
		return idle_state #if not moving return idle 
	
	if !parent.is_damaged and !parent.is_on_floor(): #if parent is not damaged any longer, and is not on floor
		return jump_state
	
	return null 


func exit() -> void:
	parent.velocity.y = 0.0 #on exit the player's velocity on x-axis will be reset 
