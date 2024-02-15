extends Bullet


# Called when the node enters the scene tree for the first time.
func _ready():
	Sounds.play(Sounds.buster_fully_charged, 1.0, -3.0)
