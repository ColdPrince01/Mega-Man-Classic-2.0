class_name Player
extends CharacterBody2D

@export var movement_data : PlayerMovementData
@export var death_time := 0.33 #amount of time the player is dead 

const ChargedLemon = preload("res://OtherScenes/charged_lemon_1.tscn")
const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")
const LemonBullet = preload("res://OtherScenes/PlayerLemon.tscn")
const ChargedLemon2 = preload("res://OtherScenes/charged_lemon_2.tscn")
const CHARGE_MEGABUSTER_START = 0.68
const FULLY_CHARGED_BUSTER_TIME = 1.6
const MAX_LEMONS = 3

@onready var character_animator = $CharacterAnimator
@onready var mega_man_sprite = $MegaManSprite
@onready var state_machine = $StateMachine
@onready var movement_component = $MovementComponent
@onready var normal_collision = $NormalCollision
@onready var slide_collision = $SlideCollision
@onready var ceiling_cast = $CeilingCast
@onready var hurt_box_component = $HurtBoxComponent
@onready var invincibility = $Invincibility
@onready var slide_dust_pos = $SlideDustPos
@onready var slide_dust = $SlideDust
@onready var dust_animation = $DustAnimation
@onready var damage_flash = $DamageFlash
@onready var stagger_timer = $StaggerTimer
@onready var mega_pos = $mega_pos
@onready var fire_rate = $FireRate
@onready var shoot_anim_timer = $ShootAnimTimer
@onready var collision_shape_2d = $RoomDetector/CollisionShape2D
@onready var climb_detector = $ClimbDetector
@onready var effect_spawner = $EffectSpawner
@onready var teleport_player = $TeleportPlayer
@onready var room_detector = $RoomDetector
@onready var camera_2d = $Camera2D

@onready var ladder_scene = get_tree().current_scene.get_node("Ladder")


var is_damaged := false
var is_sliding := false 
var is_jumping := false
var attack_hold_time = 0 #increases as attack button is pressed; used for charging mega buster
var mega_charge_lvl = 0
var can_climb := false
var is_climbing := false
var is_dead := false
var player_ready := false : set = set_player_ready
var on_spawn := false

var input_direction = Input.get_axis("ui_left","ui_right")
var vertical_direction = Input.get_axis("ui_up", "ui_down")


func _enter_tree():
	MainInstances.player = self

func _exit_tree():
	pass

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	PlayerStats.set_health(PlayerStats.max_health)
	state_machine.init(self, movement_component)
	camera_2d.position_smoothing_enabled = false
	PlayerStats.no_health.connect(death) #connect to death when the player dies 
	await get_tree().create_timer(1.15).timeout
	camera_2d.position_smoothing_enabled = true
	set_player_ready(true)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	if Input.is_action_pressed("slow_down"):
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1.0
	if Input.is_action_just_pressed("ui_down"):
		position.y += 1
	



func _physics_process(delta: float) -> void:
	if !Global.room_pause:
		state_machine.process_physics(delta)
		check_climb()
		
		
	
	


func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	attack_hold_check(delta)
	get_buster_lvl()
	buster_charge_audio(delta)



#function for making sure the player takes damage 
func _on_hurt_box_component_hurt(hitbox, damage):
	is_damaged = true #is damaged will be set to true, stagger_state properties are tied to this 
	PlayerStats.health -= damage
	invincibility.start()
	stagger_timer.start()
	hurt_box_component.is_invincible = true
	await stagger_timer.timeout
	is_damaged = false
	await invincibility.timeout
	hurt_box_component.is_invincible = false
	

func check_climb():
	if climb_detector.is_colliding():
		can_climb = true
	elif !climb_detector.is_colliding():
		can_climb = false
		is_climbing = false
	return can_climb 

func set_direction():
	if Vector2.RIGHT and input_direction > 0: #if the vector2 returns that the player is moving right
		mega_man_sprite.flip_h = false
	if Vector2.LEFT and input_direction < 0: #if the player is moving left
		mega_man_sprite.flip_h = true
	

func get_direction():
	return Vector2.LEFT if mega_man_sprite.flip_h else Vector2.RIGHT

func slide_dust_instantiation():
	slide_dust.set_as_top_level(true)
	slide_dust.global_position = slide_dust_pos.global_position
	slide_dust.flip_h = mega_man_sprite.flip_h
	dust_animation.play("dust")
	

func get_buster_lvl(): #gets mega buster lvl for charged shot
	if attack_hold_time > CHARGE_MEGABUSTER_START:
		mega_charge_lvl = 1
		PlayerSounds.play(PlayerSounds.buster_charging, 1.0, 0.0)
		
	if attack_hold_time > FULLY_CHARGED_BUSTER_TIME:
		mega_charge_lvl = 2

func buster_charge_audio(delta):
	if attack_hold_time > FULLY_CHARGED_BUSTER_TIME:
		PlayerSounds.fade_out(PlayerSounds.buster_charging, delta)
	if Input.is_action_just_released("Fire"):
		PlayerSounds.stop.call_deferred(PlayerSounds.buster_charging)
	


func attack_hold_check(delta): #Checks for if player is holding shoot button
	if Input.is_action_pressed("Fire") and fire_rate.time_left <= 0.0: #if player holds down shoot button
		if is_damaged or is_dead: return #and they aren't sliding or damaged
		if on_spawn == true: return
		attack_hold_time += delta #increase the charge hold time every second
	else:
		attack_hold_time = 0.0

func fire_bullet():
	if is_damaged or is_dead: return
	mega_pos.position.x = abs(mega_pos.position.x) * get_direction().x #marker 2d node's x position will be set equal to the absolute value of its position relative to its origin * the direction of the player
	var direction = mega_pos.position.x
	var bullet = Utils.instantiate_scene_on_world(LemonBullet, mega_pos.global_position)
	bullet.update_velocity()
	bullet.velocity.x = sign(direction) * bullet.bullet_speed


func fire_charged_bullet_one():
	if is_sliding or is_damaged or is_dead: return
	mega_pos.position.x = abs(mega_pos.position.x) * get_direction().x #marker 2d node's x position will be set equal to the absolute value of its position relative to its origin * the direction of the player
	var direction = mega_pos.position.x
	var charged_bullet = Utils.instantiate_scene_on_world(ChargedLemon, mega_pos.global_position)
	charged_bullet.update_velocity()
	charged_bullet.velocity.x = sign(direction) * charged_bullet.bullet_speed
	if direction < 0:
		charged_bullet.scale.x = -1


func fire_charged_bullet_two():
	if is_sliding or is_damaged or is_dead: return
	mega_pos.position.x = abs(mega_pos.position.x) * get_direction().x #marker 2d node's x position will be set equal to the absolute value of its position relative to its origin * the direction of the player
	var direction = mega_pos.position.x
	var charged_bullet_2 = Utils.instantiate_scene_on_world(ChargedLemon2, mega_pos.global_position)
	charged_bullet_2.update_velocity()
	charged_bullet_2.velocity.x = sign(direction) * charged_bullet_2.bullet_speed
	if direction < 0:
		charged_bullet_2.scale.x = -1
	

func death():
	#Sets state machine as inactive
	is_dead = true #sets variable for if the player is dead to true 
	
	#Screen Pause
	camera_2d.position_smoothing_enabled = false
	character_animator.play("damaged")
	get_tree().paused = true
	await(get_tree().create_timer(death_time).timeout) #creates a timer in the sceen tree and sets the wait time equal to "death_time"
	get_tree().paused = false 
	effect_spawner.spawn_death_particles(self.global_position)
	var pos = self.global_position
	camera_2d.reparent(get_tree().current_scene)
	queue_free()
	Events.player_died.emit()

func teleport_in():
	Sounds.play(Sounds.appear)

func set_player_ready(value):
	player_ready = value

func _on_room_detector_area_entered(area : Area2D):
	var collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
	var size : Vector2 = collision_shape.shape.extents * 2 #variable size set equal to the extents of the shape of the collision shape times 2
	
	
	#changes camera's current room and size. 
	camera_2d.limit_top = collision_shape.global_position.y - size.y/2
	camera_2d.limit_left = collision_shape.global_position.x - size.x/2
	camera_2d.limit_right = camera_2d.limit_left + size.x
	camera_2d.limit_bottom = camera_2d.limit_top + size.y
	
	
