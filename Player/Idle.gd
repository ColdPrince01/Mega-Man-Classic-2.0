extends State


@export var jump_state: State
@export var move_state: State
@export var slide_state: State
@export var stagger_state : State
@export var idle_state : State


var input_direction = Input.get_axis("ui_left", "ui_right")




func enter() -> void:
	super() #call everything in parent state 
	parent.velocity.x = 0
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		return idle_state
	if Input.is_action_just_pressed("ui_up") and parent.is_on_floor():
		return jump_state #return jump state if jump key is pressed and is on ground
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		return move_state #return move state is left or right key is pressed
	if Input.is_action_pressed("ui_down"):
		if Input.is_action_just_pressed("slide") and parent.is_on_floor():
			parent.slide_dust_instantiation()
			return slide_state
	if Input.is_action_just_pressed("Fire") and parent.fire_rate.time_left <= 0.0:
		parent.character_animator.play("idle_shoot") #play the idle shoot animation if fire is pressed
		parent.fire_rate.start() #start fire rate
		parent.shoot_anim_timer.start() #Animation timer set to play shoot animation
		parent.fire_bullet() #fire the bullet
	if Input.is_action_just_released("Fire"):
		if parent.mega_charge_lvl == 1:
			parent.character_animator.play("idle_shoot") #play the idle shoot animation if fire is pressed
			parent.shoot_anim_timer.start() #Animation timer set to play shoot animation
			parent.fire_charged_bullet_one()
			parent.attack_hold_time = 0.0
			parent.mega_charge_lvl = 0
		if parent.mega_charge_lvl == 2:
			parent.character_animator.play("idle_shoot") #play the idle shoot animation if fire is pressed
			parent.shoot_anim_timer.start() #Animation timer set to play shoot animation
			parent.fire_charged_bullet_two()
			parent.attack_hold_time = 0.0
			parent.mega_charge_lvl = 0
		else:
			return null
	
	return null #return nothing if no input is recieved
	

func process_physics(delta: float) -> State:
	parent.velocity.y += movement_data.gravity * delta #at every physics step apply gravity
	parent.move_and_slide() #call move_and_slide after
	
	if parent.is_damaged: #this has to be before the other state checks (idk why)
		print("idle stagger")
		return stagger_state
	
	if parent.shoot_anim_timer.time_left > 0.0: #while there's time left on the timer 
		parent.character_animator.play("idle_shoot") #play the idle shoot animation
	
	if parent.shoot_anim_timer.time_left <= 0.0: #if there is no time left on the animation timer
		return idle_state #return to idle animation
	

	
	
	if !parent.is_on_floor() and parent.velocity.y > 0.0: #if parent is not on floor and is falling
		return jump_state #return fall state
	return null #otherwise if nothing is happening return nothing and stay idle 
	
	

