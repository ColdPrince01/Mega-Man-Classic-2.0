class_name Camera
extends Camera2D

var shake = 0
var current_pos
var player = MainInstances.player
var in_transit := false
var zoom_view_size: Vector2
var smoothing : float

var current_room_center: Vector2
var current_room_size: Vector2

@onready var view_size: Vector2 = get_viewport_rect().size
@onready var screen_shake = $ScreenShake
@onready var ready_blink = $ReadyBlink

@export var follow_smoothing := 0.1
@export var player_on_path : CharacterBody2D
@export var world : Node2D

func _enter_tree():
	MainInstances.camera = self

func _exit_tree():
	MainInstances.camera = null

func _ready():
	
	ready_blink.play("blink")
	await(get_tree().create_timer(1.15).timeout)
	ready_blink.stop()
	position_smoothing_enabled = false 
	smoothing = 1
	await(get_tree().create_timer(0.1).timeout)
	smoothing = follow_smoothing
	
	Events.add_screenshake.connect(set_screenshake)
	
	

func _physics_process(delta):
	zoom_view_size = view_size * zoom
	
	#var target position is set to calculate target position with current room center and size
	var target_position := calculate_target_position(current_room_center, current_room_size)
	
	#interpolates camera position to target position by the smoothing passed in
	position = lerp(position, target_position, smoothing)
	


func _process(delta):
	offset.x = randf_range(-shake, shake)
	offset.y = randf_range(-shake, shake)
	


func calculate_target_position(room_center : Vector2, room_size: Vector2) -> Vector2:
	var x_margin : float = (room_size.x - zoom_view_size.x) / 2
	var y_margin : float = (room_size.y - zoom_view_size.y) / 2
	
	var return_position : Vector2 = Vector2.ZERO
	
	if x_margin <= 0:
		return_position.x = room_center.x
	else:
		var left_limit : float = room_center.x - x_margin
		var right_limit : float = room_center.x + x_margin
		if Global.player != null: #if the player is not currently a null instance 
			return_position.x = clamp(Global.player.position.x, left_limit, right_limit) #return the player's position
		else: #otherwise if in any other case, the player is indeed a null instance
			var cam_pos = get_screen_center_position() #var cam_pos x is equal to whatever the current center position is
			return_position.x = cam_pos.x #return the current cam position
	
	if y_margin <= 0:
		return_position.y = room_center.y
	else:
		var top_limit : float = room_center.y - y_margin
		var bottom_limit : float = room_center.y + y_margin
		if Global.player != null: #if the player is not currently a null instance 
			return_position.y = clamp(Global.player.position.y, top_limit, bottom_limit) #return the player's position
		else: #otherwise if in any other case, the player is indeed a null instance
			var cam_pos = get_screen_center_position() #var cam_pos y is equal to whatever the current center position is
			return_position.y = cam_pos.y #return the current cam position
	
	return return_position

func update_limits(left, right, top, bottom):
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom
	print("limits updated")



func set_screenshake(magnitude, duration):
	shake = magnitude #shake strength is equal to magnitude passed in 
	screen_shake.wait_time = duration #screen shake time is equal to magnitude passed in
	screen_shake.start()


func _on_screen_shake_timeout():
	shake = 0
