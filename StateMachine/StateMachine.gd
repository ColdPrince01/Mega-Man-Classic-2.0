class_name State
extends Node


#a script made for the purpose of compartmentalizing aspects of the code in order to handle the character's various states 
@export var movement_data : PlayerMovementData
@export var animation_name : String

signal shot_fired

var parent: Player #variable parent is set to the player class bodies
var move_component
var state_velocity = Vector2()



#first method called when the state enters the scene, any properties passed in here will carry over to any relevant method that requires it 
func enter() -> void:
	parent.character_animator.play(animation_name) #upon entering scene, state will play animation name 
	
	
#function called when the state is exited, last function called 
func exit() -> void:
	pass
	

#function for processing player input 
func process_input(event: InputEvent) -> State:
	return null
	

#function for processing tied to idle frames
func process_frame(delta: float) -> State:
	return null
	

#function for processing, tied to physics frames 
func process_physics(delta: float) -> State:
	return null


func get_movement_input() -> float:
	return move_component.get_movement_direction() #return the movement component obtaining player movement direction
