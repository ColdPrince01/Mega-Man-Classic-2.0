extends CharacterBody2D

@export var gravity = 980
@export var fall_speed = 210.0
@export var drag_speed = 110.0

@onready var grab_timer = $GrabTimer
@onready var animation_player = $AnimationPlayer
@onready var player_grabber = $PlayerGrabber
@onready var player_finder = $PlayerFinder
@onready var finder_pos = $PlayerFinder/CollisionShape2D
@onready var grabber_pos = $PlayerGrabber/CollisionShape2D

var grip_done := false

func _ready():
	pass



func _physics_process(delta):
	var player = MainInstances.player
	if player != null:
		if player_finder.overlaps_body(player):
			velocity.y += gravity * delta
			velocity.y = clamp(velocity.y, -fall_speed * 3, fall_speed * 3)
			velocity.x = 0.0
		if player_grabber.overlaps_body(player):
			finder_pos.set_deferred("disabled", true)
			animation_player.play("gripped_on")
			player.global_position = grabber_pos.global_position 
			velocity.y = player.velocity.y
			velocity.x = drag_speed
			player.velocity.x = self.velocity.x
			
		
		elif !player_finder.overlaps_body(player):
			velocity.x = 0.0
			velocity.y = 0.0
	else:
		velocity.y -= fall_speed * delta
		velocity.x = 0.0
		finder_pos.set_deferred("disabled", true)
		grabber_pos.set_deferred("disabled", true)
	if grip_done:
		grabber_pos.set_deferred("disabled", true)
		velocity.y -= fall_speed
		velocity.x = 0.0
	
	
	if player.is_dead:
		grip_done = true
	
	move_and_slide()





func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_grab_timer_timeout():
	grip_done = true
	finder_pos.set_deferred("disabled", true)
	grabber_pos.set_deferred("disabled", true)


func _on_player_grabber_body_entered(body):
	grab_timer.start()
