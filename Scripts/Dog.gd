extends "res://Scripts/Animals.gd"

onready var parent = get_parent()

var target = null
var following = false
var _velocity = Vector2.ZERO

const DISTANCE_THRESHOLD: = 140.0

#if there's a pathfollow, use this.

func _ready():
	$Body.play("Idle")
	set_process(true)


func _physics_process(delta):
	if target == null:
		if following == false:
			if parent is PathFollow2D:
				parent.set_offset(parent.get_offset() + speed / 3 * delta)
				position = Vector2()
				$Body.play("Walk")
			else:
				$Body.stop()
	
	if target:
#		if following == false:
			
		if following == true:
			if global_position.distance_to(target.position) < DISTANCE_THRESHOLD:
				return
			
			_velocity = Steering.follow(
				_velocity,
				global_position,
				target.position,
#					speed should be max_speed instead
				speed
			)
			_velocity = move_and_slide(_velocity)
			$Body.global_rotation = _velocity.angle()

#This is the process that the script user follows at start
func _process(delta):
	if Input.is_action_just_pressed('ui_4'):
		print(global_position.distance_to(target.position) < DISTANCE_THRESHOLD)

	if target:
		if following == true:
			if $Body.is_playing() == true:
				if $Body.get_animation() != "Walk":
					$Body.play("Walk")
				else:
					pass
			#		if target_dir.dot(current_dir) >0.9:
#					shoot()
		if Input.is_action_just_pressed('ui_f'):
			if following == false:
				following = true
				print(following)
			else:
				following = false
				print(following)

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body
#		Put noget her med emotes hvor kunden hilser osv.


func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
		$Body.play("Idle")
#		ved ikke helt hvordan jeg skal få ham tilbage til sin tidligere rotation før entry
#		$Body.global_rotation = 0