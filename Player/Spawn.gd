extends State


@export var idle_state : State
@export var spawn_time := 0.6

var spawn_timer := 0.0

func enter() -> void:
	
	parent.teleport_player.play("teleport_in")
	spawn_timer = spawn_time
	
func process_input(event: InputEvent) -> State:
	return null
	

func process_physics(delta: float) -> State:
	spawn_timer -= delta
	if spawn_timer <= 0.0:
		return idle_state
	return null
