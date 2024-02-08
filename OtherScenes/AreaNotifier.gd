extends ReferenceRect

#made to notify player if player is within the area of this node

signal player_entered_area

var is_player_in_area = false #Player's interaction checks

func _on_area_2d_area_entered(area):
	if area is Player:
		is_player_in_area = true #Player's interaction checks
		


func _on_area_2d_area_exited(area):
	if area is Player:
		is_player_in_area = false #Player's interaction checks
		

func entered_area():
	if MainInstances.player == null:
		return
	emit_signal("entered_area")
