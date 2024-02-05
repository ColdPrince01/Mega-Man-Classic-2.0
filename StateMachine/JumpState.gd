extends State

@export var idle_state: State
@export var move_state: State
@export var stagger_state : State

@export var buster_pos := Vector2(20, -1)

func enter() -> void:
	super() #call every line in the enter method in the State Class
	state_velocity = parent.velocity.y
	parent.mega_pos.position.y -= 7
	if parent.velocity.y <= 0.0 and parent.is_on_floor():
		parent.velocity.y = -movement_data.jump_velocity #set parent's velocity equal to jump force


func process_input(event: InputEvent) -> State:
	if not parent.is_on_floor():
		if Input.is_action_just_released("ui_up") and parent.velocity.y < 0.0: #for when the jump button is released
			parent.velocity.y = -movement_data.jump_velocity / 10 #lowers jump to 1/10th of its typical trajectory 
	if Input.is_action_just_pressed("Fire") and parent.fire_rate.time_left <= 0.0:
		print(parent.mega_pos.global_position)
		parent.character_animator.play("jump_shoot")
		parent.fire_rate.start()
		parent.shoot_anim_timer.start() #Animation timer for the player's shoot button 
		parent.fire_bullet()
	if Input.is_action_just_released("Fire"):
		if parent.mega_charge_lvl == 1:
			parent.character_animator.play("jump_shoot")
			parent.shoot_anim_timer.start() #Animation timer for the player's shoot button 
			parent.fire_charged_bullet_one()
			parent.attack_hold_time = 0.0
			parent.mega_charge_lvl = 0
		if parent.mega_charge_lvl == 2:
			parent.fire_charged_bullet_two()
			parent.character_animator.play("jump_shoot")
			parent.shoot_anim_timer.start() #Animation timer for the player's shoot button 
			parent.attack_hold_time = 0.0
			parent.mega_charge_lvl = 0
		else:
			return null
	
	return null


#function handles physics process for jumping, will be sent up to the player script and processed under the _physics_process(): function
func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta
	parent.velocity.y = clamp(parent.velocity.y, -movement_data.max_fall_speed, movement_data.max_fall_speed)
	
	if parent.is_damaged: #if the player gets damaged 
		return stagger_state
	
	var input_direction = Input.get_axis("ui_left","ui_right")
	
	if input_direction != 0: #if the player is moving
		parent.mega_man_sprite.flip_h = input_direction < 0 #whether or not the player sprite flips is determined by the direction of movement
	parent.velocity.x = input_direction * movement_data.move_speed
	parent.move_and_slide() #call move and slide after movement calculations
	
	if parent.shoot_anim_timer.time_left <= 0.0:
		parent.character_animator.play("jump")
	
	if parent.is_on_floor(): #if the player is on the floor
		if input_direction != 0: #and they are moving
			return move_state #set state = to move state
		return idle_state #if on the floor and not moving, set state = idle_state
	
	return null #if nothing changes return null 


func exit() -> void:
	Sounds.play(Sounds.land)
	parent.mega_pos.position = buster_pos


