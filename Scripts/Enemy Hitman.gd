extends "res://Scripts/People.gd"

onready var parent = get_parent()

#export (int) var detect_radius

var target = null

#if there's a pathfollow, use this.

func _ready():
	set_process(true)

#This is the process that the script user follows at start
func _process(delta):
	if target == null:
		if parent is PathFollow2D:
			parent.set_offset(parent.get_offset() + speed * delta)
			position = Vector2()
			$Body.play("Walk")
		else:
		# other movement code
			pass
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
		$Body.global_rotation = current_dir.linear_interpolate(target_dir, speed * delta).angle()
		if target_dir.dot(current_dir) >0.9:
			shoot()

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		target = body
		$Body.play("DrawGun")


func _on_DetectRadius_body_exited(body):
	if body == target:
		target = null
		$Body.play("Walk")
		$Body.stop()
		$Body.set_frame(0)
#		ved ikke helt hvordan jeg skal få ham tilbage til sin tidligere rotation før entry
		$Body.global_rotation = 0