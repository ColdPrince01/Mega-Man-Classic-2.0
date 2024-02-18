extends Bullet


func _ready():
	Sounds.play(Sounds.enemy_bullet)

func _process(delta):
	position += direction.normalized() * velocity * delta
