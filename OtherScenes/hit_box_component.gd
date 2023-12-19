class_name Hitbox
extends Area2D

#reminder to set layer/mask whenever this component is added to a node

@export var damage = 1 #editable damage value 



func _on_area_entered(hurtbox):
	if not hurtbox is HurtBox: return #only run the function if the area entered is a hurt box, else return
	hurtbox.take_hit(self, damage) #will connect to the hurtbox entered and pass in the object(self) which entered the area as well as the damage done
	# will result in take_hit signal being emit
