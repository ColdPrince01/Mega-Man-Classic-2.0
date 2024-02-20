class_name Teleporter
extends Node2D


@export var next_portal : Teleporter
@export var eject_speed := 480.0





@onready var animation_player = $AnimationPlayer


var next_port
var previous_port












func _on_enter_area_body_entered(body):
	Sounds.play(Sounds.teleporter)
	var player = MainInstances.player as Player
	if not player is Player: return
	var next_port = next_portal.global_position
	animation_player.play("teleport_in")
	player.global_position = next_port - Vector2(0, 12)
	player.velocity.y = 0.0
	Events.has_control.emit(false)


func _on_enter_area_body_exited(body):
	var player = MainInstances.player as Player
	if not player is Player: return
	player.velocity.y -= eject_speed
	if animation_player.current_animation == "teleport_in": await animation_player.animation_finished
	animation_player.play("teleport_out")
	await animation_player.animation_finished
	animation_player.play("Idle")
	Events.has_control.emit(true)
	
