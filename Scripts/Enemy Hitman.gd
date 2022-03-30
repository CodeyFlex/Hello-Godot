extends "res://Scripts/People.gd"

onready var parent = get_parent()

#export (int) var detect_radius

var target = null
onready var detection_timer : Timer = $HearingDetectionTimer
onready var eyes_vision_cone : CollisionShape2D = $Body/EyesDetectRadius/EyesVisionShape
var hearing_detected_body : KinematicBody2D = null

# Part of Better_Patrol_Path
export (NodePath) var patrol_pathfollow
export (NodePath) var patrol_path #Allows insertion of path directly in inspector
var patrol_points
var patrol_index = 0

const DISTANCE_THRESHOLD: = 240.0 # How close it gets to the followed before it stops

func _ready():
	set_process(true)
	# Part of Better_Patrol_Path
	if patrol_path:
		patrol_points = get_node(patrol_path).curve.get_baked_points()

#This is the process that the script user follows at start
func _process(delta):
	if not alive:
		return
	
	#Debug
#	if Input.is_action_pressed('ui_5'):
#		print("Target: ", target, "Detection Time Left: ", detection_timer.time_left, "Path Available? ", path_available)
	
	if target == null && hearing_detected_body == null && health > (max_health / 2):
		pass
#		better_patrol_path()
#		patrol_the_path(delta) #Old and bad and mad and sad

	if path_available == true:
		var move_distance = speed * delta
		move_along_path(move_distance)

	if target:
		shoot_target(delta, target)
		if health > (max_health / 2):
			follow_target()

#This path follow doesn't teleport him, but instead doesn't rotate and has to be parented to path even though it's exported
func better_patrol_path():
	if !patrol_path:
		return
	var patrol_target = patrol_points[patrol_index]
	if position.distance_to(patrol_target) < 1: # Starts patrolling path when close to it
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size()) #Using wrapi to loop to first point of path
		patrol_target = patrol_points[patrol_index]
	_velocity = (patrol_target - position).normalized() * speed
	_velocity = move_and_slide(_velocity)
	$Body.play("Walk")
	$Body.global_rotation = _velocity.angle()

#func patrol_the_path(delta):
#	if parent is PathFollow2D:
#		$Body.rotation = 0
#		# Below = (Starting position in path, speed from node for every delta call)
#		parent.set_offset(parent.get_offset() + speed * delta)
#		position = Vector2()
#		$Body.play("Walk")
#	else:
#	# other movement code
#		pass

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
	
func shoot_target(delta, current_target):
	eyes_vision_cone.set_scale(Vector2(3, 3)) # Alert vision cone size
	var target_dir = (current_target.global_position - global_position).normalized()
	var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
	$Body.global_rotation = current_dir.linear_interpolate(target_dir, speed * delta).angle()
	if target_dir.dot(current_dir) >0.9:
		shoot()

func _on_EyesDetectRadius_body_entered(body):
	if body.name == "Player":
		target = body
		$Body.play("DrawGun")


func _on_EyesDetectRadius_body_exited(body):
	if body == target:
		target = null
		$Body.play("Walk")
		$Body.stop()
		$Body.set_frame(0)
#		ved ikke helt hvordan jeg skal få ham tilbage til sin tidligere rotation før entry
		$Body.global_rotation = 0
		eyes_vision_cone.set_scale(Vector2(1, 1)) # Casual vision cone size


func _on_EarsDetectRadius_body_entered(body): #Create a detection when player is running nearby
	detection_timer.start()
	if body.name == "Player":
		hearing_detected_body = body
		$Body.play("DrawGun")
	#Something where an exclamation mark appears above the character
	#And after 3 sec, the character turns around towards the noise
	#Giving the player time to act

func _on_EarsDetectRadius_body_exited(body): #Create a leaves detection when player is running nearby
	if body.name == "Player":
		detection_timer.stop()
		hearing_detected_body = null

func _on_HearingDetectionTimer_timeout():
	if hearing_detected_body != null:
		if hearing_detected_body.name == "Player":
			target = hearing_detected_body
			$Body.play("DrawGun")
