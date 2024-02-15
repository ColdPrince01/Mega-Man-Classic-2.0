extends Node

@export var init_state : State #variable for initial state, pass in for every different state

var current_state : State
var active := true

func init(parent: Player, move_component) -> void:
	for child in get_children(): #iterate over every child node the player has, made it a child of the state machine
		child.parent = parent #set the parent of every state to be equal to the player 
		child.move_component = move_component #grabs move_component passed in from the parent and passes it to the child 
		
		
	
	change_state(init_state) #initialize to default state

#function for handling any operations which need handling during every physics frame (60 times every frame)
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
	
#function for handling any operations which need handling during every idle frame (delta time)
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)


func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)


#function for when the state changes to another state, asks for new state which inherits from state machine 
func change_state(new_state: State) -> void:
	if current_state: #if on current state
		current_state.exit() #exit current state
		
	current_state = new_state #set new state equal to current state
	current_state.enter() #call enter function for new state 

