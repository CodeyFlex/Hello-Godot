extends "res://Scripts/Animals.gd"

onready var parent = get_parent()

var target = null
var following = false
var _velocity = Vector2.ZERO

const DISTANCE_THRESHOLD: = 140.0 # How close it gets to the followed before it stops

#if there's a pathfollow, use this.

func _ready():
	$Body.play("Idle")
	set_process(true)

func _physics_process(delta):
	if target == null:
		if following == false:
			patrol_path(delta)
	
	if target:
	#	if following == false:
	# Code the dog to look at the player when the player is in view.
	# Not currently rotating properly with the established code for other NPC's.
			
		if following == true:
			follow_target()

#This is the process that the script user follows at start
func _process(delta):
	if target:
		#Plays walk animation when following
		if following == true:
			if $Body.is_playing() == true:
				#Checks if walk animation is plaiyng, plays it if not.
				if $Body.get_animation() != "Walk":
					$Body.play("Walk")
				else:
					pass

		#Makes dog follow the player
		if Input.is_action_just_pressed('ui_f'):
			if following == false:
				following = true
				print("Is following: ", following)
			else:
				following = false
				print("Is following: ", following)

func follow_target():
	# Stops follower from getting too close
	if global_position.distance_to(target.position) < DISTANCE_THRESHOLD:
		return
	# Follows target
	_velocity = Steering.follow(
	_velocity,
	global_position,
	target.position,
	speed
	)
	_velocity = move_and_slide(_velocity)
	$Body.global_rotation = _velocity.angle()

func patrol_path(delta):
	if parent is PathFollow2D:
		$Body.rotation = 0
		parent.set_offset(parent.get_offset() + speed / 3 * delta)
		position = Vector2()
		$Body.play("Walk")
	else:
		$Body.stop()

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
