class_name Player
extends CharacterBody2D

@export var movement_data : PlayerMovementData

const ChargedLemon = preload("res://OtherScenes/charged_lemon_1.tscn")
const ExplosionEffectScene = preload("res://OtherScenes/explosion_effect.tscn")
const LemonBullet = preload("res://OtherScenes/PlayerLemon.tscn")
const ChargedLemon2 = preload("res://OtherScenes/charged_lemon_2.tscn")
const CHARGE_MEGABUSTER_START = 0.6
const FULLY_CHARGED_BUSTER_TIME = 1.6


@onready var character_animator = $CharacterAnimator
@onready var mega_man_sprite = $MegaManSprite
@onready var state_machine = $StateMachine
@onready var movement_component = $MovementComponent
@onready var camera_2d = $Camera2D
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


var is_damaged := false
var is_sliding := false 
var is_jumping := false
var attack_hold_time = 0 #increases as attack button is pressed; used for charging mega buster
var mega_charge_lvl = 0

var input_direction = Input.get_axis("ui_left","ui_right")


func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self, movement_component)
	PlayerStats.no_health.connect(death) #connect to death when the player dies 

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	if Input.is_action_pressed("ui_accept"):
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1.0


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	attack_hold_check(delta)
	get_buster_lvl()
	print(mega_charge_lvl)



#function for making sure the player takes damage 
func _on_hurt_box_component_hurt(hitbox, damage):
	is_damaged = true #is damaged will be set to true, stagger_state properties are tied to this 
	Sounds.play(Sounds.hurt)
	PlayerStats.health -= damage
	invincibility.start()
	stagger_timer.start()
	hurt_box_component.is_invincible = true
	await stagger_timer.timeout
	is_damaged = false
	await invincibility.timeout
	hurt_box_component.is_invincible = false
	


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
	if attack_hold_time > FULLY_CHARGED_BUSTER_TIME:
		mega_charge_lvl = 2


func attack_hold_check(delta): #Checks for if player is holding shoot button
	if Input.is_action_pressed("Fire") and fire_rate.time_left <= 0.0: #if player holds down shoot button
		if is_sliding or is_damaged: return #and they aren't sliding or damaged
		attack_hold_time += delta #increase the charge hold time every second
	else:
		attack_hold_time = 0.0

func fire_bullet():
	if is_damaged: return
	mega_pos.position.x = abs(mega_pos.position.x) * get_direction().x #marker 2d node's x position will be set equal to the absolute value of its position relative to its origin * the direction of the player
	var direction = mega_pos.position.x
	var bullet = Utils.instantiate_scene_on_world(LemonBullet, mega_pos.global_position)
	bullet.update_velocity()
	bullet.velocity.x = sign(direction) * bullet.bullet_speed


func fire_charged_bullet_one():
	if is_sliding or is_damaged: return
	mega_pos.position.x = abs(mega_pos.position.x) * get_direction().x #marker 2d node's x position will be set equal to the absolute value of its position relative to its origin * the direction of the player
	var direction = mega_pos.position.x
	var charged_bullet = Utils.instantiate_scene_on_world(ChargedLemon, mega_pos.global_position)
	charged_bullet.update_velocity()
	charged_bullet.velocity.x = sign(direction) * charged_bullet.bullet_speed
	if direction < 0:
		charged_bullet.scale.x = -1


func fire_charged_bullet_two():
	if is_sliding or is_damaged: return
	mega_pos.position.x = abs(mega_pos.position.x) * get_direction().x #marker 2d node's x position will be set equal to the absolute value of its position relative to its origin * the direction of the player
	var direction = mega_pos.position.x
	var charged_bullet_2 = Utils.instantiate_scene_on_world(ChargedLemon2, mega_pos.global_position)
	charged_bullet_2.update_velocity()
	charged_bullet_2.velocity.x = sign(direction) * charged_bullet_2.bullet_speed
	if direction < 0:
		charged_bullet_2.scale.x = -1
	

func death():
	#temp death functionality 
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position + Vector2(0,-7))
	queue_free()
