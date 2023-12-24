extends Node

@export var init_state : State #variable for initial state 

var current_state : State
var states : Dictionary = {} #variable states set to empty dictionary

func _ready():
	for child in get_children(): #iterate over all the children nodes in the statemachine
		if child is State: #if the for loop catches a child that inherits state 
			states[child.name.to_lower()] = child #add state to the dictionary as a child
			child.Transitioned.connect(on_child_transition) #on ready, connect to the query of whenever the child state has transitioned
		
	if init_state: #if initial state exists
		init_state._enter() #enter with the initial state
		current_state = init_state #set initial state as current state 


func _process(delta):
	if current_state:
		current_state._update(delta)
	
	

func _physics_process(delta):
	if current_state: #if current state is active
		current_state.physics_update(delta)


#function for when the child transitions to a new state, asks for current state, and new state name
func on_child_transition(state, new_state_name):
	if state != current_state: #if the state calling the transition is the current state
		return #return
		
	var new_state = states.get(new_state_name.to_lower()) #grab new state from state dictionary 
	if !new_state: #if there is no new state
		return #return
	
	if current_state: #if on current state
		current_state.exit() #exit the state
		
	new_state.enter() #enter the new state
	
	current_state = new_state #set new state as the new current state
