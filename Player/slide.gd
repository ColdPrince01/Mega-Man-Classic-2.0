extends State

@export var slide_state : State 
@export var idle_state : State
@export var move_state : State
@export var jump_state : State
@export var stagger_state : State

@export var slide_time := 0.5

var direction := 1
var slide_timer := 0.0
var timer_paused := false



func enter() -> void:
	super()
	#upon entering the state, the player's collision has to be set, but the call must be deffered else the collision will get wonky
	parent.slide_collision.set_deferred("disabled", false) #upon entering state, set slide collider to be on
	parent.normal_collision.set_deferred("disabled", true) #set normal collider to be off 
	slide_timer = slide_time
	parent.velocity.y = 0.0
	parent.is_sliding = true
	
	if parent.mega_man_sprite.flip_h: #if the player sprite is flipped
		direction = -1 #direction is equal to left 
	else: #otherwise
		direction = 1 #direction is equal to right  

func process_input(event: InputEvent) -> State:
	#if the player taps left while moving right, or taps right while moving left
	if Input.is_action_just_pressed("ui_left") and direction == 1 or Input.is_action_just_pressed("ui_right") and direction == -1:
		if !parent.ceiling_cast.is_colliding():
			return move_state #exit state 
	return null
	

func process_physics(delta: float) -> State:
	if timer_paused == false: slide_timer -= delta #decrease slide_timer value every second
	if slide_timer <= 0.0:
		if get_movement_input() !=0:
			return move_state
		return idle_state
		
	parent.velocity.x = movement_data.slide_speed * direction #calculate movement for slide
	parent.move_and_slide() #call move and slide after
	
	if !parent.is_on_floor(): #if the player is not on the floor
		return jump_state #return jump state 
		
	
	if parent.is_damaged:
		return stagger_state
	
	if parent.ceiling_cast.is_colliding(): #if the ceiling cast detects a ceiling 
		timer_paused = true #stop counting down slide_timer
	else: #otherwise
		timer_paused = false #the timer should keep counting down
	return null #if nothing happens return nothing

func exit():
	parent.slide_collision.set_deferred("disabled", true) 
	parent.normal_collision.set_deferred("disabled", false)
	parent.is_sliding = false
	if parent.mega_charge_lvl > 0:
		if not parent.attack_hold_time > 0.0:
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
