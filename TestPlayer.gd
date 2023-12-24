class_name Player
extends CharacterBody2D

@export var movement_data : PlayerMovementData

@onready var character_animator = $CharacterAnimator
@onready var mega_man_sprite = $MegaManSprite
@onready var state_machine = $StateMachine
@onready var movement_component = $MovementComponent
@onready var camera_2d = $Camera2D
@onready var normal_collision = $NormalCollision
@onready var slide_collision = $SlideCollision
@onready var ceiling_cast = $CeilingCast



var input_direction = Input.get_axis("ui_left","ui_right")

func _ready() -> void:
		# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self, movement_component)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
