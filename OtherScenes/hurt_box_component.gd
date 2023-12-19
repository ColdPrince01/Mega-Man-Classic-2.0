class_name HurtBox
extends Area2D


signal hurt(hitbox, damage) #signal for when a node has been hurt, asks for the hitbox which hit and the damage

var is_invincible = false :
	set(value):
		is_invincible = value
		disable.call_deferred(value)

#function for emiting hurt signal
func take_hit(hitbox, damage):
	if is_invincible: return
	hurt.emit(hitbox, damage)# when the hitbox enters the hurtbox area the signal will be emit

#function for disabling hitbox temporarily
func disable(value):
	for child in get_children(): #for loop to find collision shape 
		if child is CollisionPolygon2D or CollisionShape2D: #if it finds a collision shape
			child.disabled = value #disable value is equal to value passed in

