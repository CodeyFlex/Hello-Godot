extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime
var shooter_of_bullet

var velocity = Vector2()

func start(_position, _direction, shooter):
	shooter_of_bullet = shooter
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	velocity = _direction * speed
	
func _process(delta):
	position += velocity * delta

#Removes scene instance from game
func explode():
		queue_free()

func _on_Bullet_body_entered(body):
	explode()
	if body != shooter_of_bullet:
		if body.has_method('take_damage'):
			body.take_damage(damage)
		if body.has_method('update_health_bar'):
			body.update_health_bar()

func _on_Lifetime_timeout():
	explode()
