extends Sprite2D

const MAX_TIP_TOE_FRAME = 7

@export var parent_player : NodePath
@export var animation_paused = false


@onready var character_animator = $CharacterAnimator
@onready var shot_cooldown = $ShotCooldown
@onready var player = get_parent()

var is_damaged : bool = false
var is_sliding : bool = false 
var launching_bullet : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func start_attack_animation():
	shot_cooldown.start()
	launching_bullet = true

func _on_shot_cooldown_timeout():
	launching_bullet = false

func handle_animation():
	if is_damaged:
		if not is_sliding:
			character_animator.play("damaged")
		else:
			pass
			#add damaged slide animation here
	elif player.is_on_floor():
		if launching_bullet:
			if not is_sliding:
				if player.is_moving():
					if player.key_pressed_time < MAX_TIP_TOE_FRAME:
						character_animator.play("tip_toe_shoot")
					else:
						character_animator.play("shooting_walk")
				else:
					character_animator.play("idle_shoot")
			else:
				pass
		else:
			if not is_sliding:
				if player.is_moving():
					if player.key_pressed_time < MAX_TIP_TOE_FRAME:
						character_animator.play("tip_toe")
					else:
						character_animator.play("run")
				else:
					character_animator.play("idle")
			else:
				character_animator.play("slide")
	else:
		if launching_bullet:
			if not player.is_on_floor():
				character_animator.play("jump_shoot")
		else:
			if not player.is_on_floor():
				character_animator.play("jump")
