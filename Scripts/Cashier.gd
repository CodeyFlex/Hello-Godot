extends "res://Scripts/People.gd"

onready var parent = get_parent()

var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

#This is the process that the script user follows at start
func _process(delta):
	if not alive:
		return
	
	# Follow path
	if path_available == true:
		var move_distance = speed * delta
		move_along_path(move_distance)
	
	# Reset rotation if not looking at anyone
	if target == null:
		$Body.rotation = 270

	if target:
		look_at_target(delta)

func look_at_target(delta):
	var target_dir = (target.global_position - global_position).normalized()
	var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
	$Body.stop() #Stops movement animation
	$Body.set_frame(0) #Reset to no hands out
	$Body.global_rotation = current_dir.linear_interpolate(target_dir, speed * delta).angle()

func _on_DetectRadius_body_entered(body):
	target = body

func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
