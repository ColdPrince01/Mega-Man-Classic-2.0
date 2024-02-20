extends Node

signal add_screenshake(magnitude, duration) #signal for screenshake, asks for strength/madnitude, and length (seconds)
signal add_transition(transition)
signal camera_limits_changed(left, right, top, bottom)
signal shot_fired(scene, position)
signal transit_screen(direction, duration) #Signal for when a player has hit a screen transitor
signal change_active(current_screen, new_screen)
signal player_died
signal player_ready(value)
signal reflected()
signal has_control(value)
