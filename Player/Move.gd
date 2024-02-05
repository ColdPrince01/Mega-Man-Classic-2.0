extends State
class_name MoveState

@export var idle_state : State
@export var jump_state : State
@export var slide_state : State 
@export var stagger_state : State

var current_animation_pos: float #variable for grabbing the current animation

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		return idle_state
	if Input.is_action_just_pressed("ui_up") and parent.is_on_floor(): #if jump button pressed and parent is on floor
		return jump_state
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("slide") and parent.is_on_floor():
			parent.slide_dust_instantiation()
			return slide_state
	if Input.is_action_just_pressed("Fire") and parent.fire_rate.time_left <= 0.0:
		current_animation_pos = parent.character_animator.current_animation_position #sets variable current animation pos equal to where the animation is on the running animation
		parent.character_animator.play("shooting_walk")
		parent.character_animator.seek(current_animation_pos, true)
		parent.fire_rate.start()
		parent.shoot_anim_timer.start() #Animation timer for the player's shoot button 
		parent.fire_bullet()
	if Input.is_action_just_released("Fire"):
		if parent.mega_charge_lvl == 1:
			current_animation_pos = parent.character_animator.current_animation_position #sets variable current animation pos equal to where the animation is on the running animation
			parent.character_animator.play("shooting_walk")
			parent.character_animator.seek(current_animation_pos, true)
			parent.shoot_anim_timer.start()
			parent.fire_charged_bullet_one()
			parent.attack_hold_time = 0.0
			parent.mega_charge_lvl = 0
		if parent.mega_charge_lvl == 2:
			current_animation_pos = parent.character_animator.current_animation_position #sets variable current animation pos equal to where the animation is on the running animation
			parent.character_animator.play("shooting_walk")
			parent.character_animator.seek(current_animation_pos, true)
			parent.shoot_anim_timer.start()
			parent.fire_charged_bullet_two()
			parent.attack_hold_time = 0.0
			parent.mega_charge_lvl = 0
		else:
			return null
	
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	
	
	var input_direction = get_movement_input()
	
	if input_direction == 0: #if the player stops moving
		return idle_state #return idle state
		
	
	if parent.shoot_anim_timer.time_left <= 0.0:
		current_animation_pos = parent.character_animator.current_animation_position #current animation position is set to what megaman's current position is at (seconds of animation elapsed)
		parent.character_animator.play("run") #play the run animation
		parent.character_animator.seek(current_animation_pos, true) #make sure to seek the same frame as was set when playing "shoot run" animation
	
	parent.mega_man_sprite.flip_h = input_direction < 0 #if movement is negative, flip sprite
	parent.velocity.x = input_direction  * movement_data.move_speed
	parent.move_and_slide() #call move and slide after calculating velocity 
	
	if parent.is_damaged:
		return stagger_state
	
	if !parent.is_on_floor(): #if player is in the air 
		return jump_state
	return null #return nothing, if nothing is happening 
