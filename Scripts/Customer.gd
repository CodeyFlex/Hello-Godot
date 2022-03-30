extends "res://Scripts/People.gd"

onready var parent = get_parent()

var target = null

#if there's a pathfollow, use this.

func _ready():
	set_process(true)

#This is the process that the script user follows at start
func _process(delta):
	#Autoamatic Pathfollow
	if target == null:
		if parent is PathFollow2D:
			$Body.rotation = 0
			#Below = (Starting position in path, speed from node for every delta call)
			parent.set_offset(parent.get_offset() + speed * delta)
			position = Vector2()
			$Body.play("Walk")
		#Stop movement & move animation if target present
		else:
			$Body.stop()

	#Look at target
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
		$Body.stop() #Stops movement animation
		$Body.set_frame(0) #Reset to no hands out
		$Body.global_rotation = current_dir.linear_interpolate(target_dir, speed * delta).angle()

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body
#		Put noget her med emotes hvor kunden hilser osv.


func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
