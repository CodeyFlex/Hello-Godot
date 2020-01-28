extends "res://Scripts/People.gd"

var ACCELERATION = 6000
var motion = Vector2.ZERO

var Gun_Drawn = true

#Get player direction input
func _physics_process(delta):
	#Body kommer fra people scenen
	$Body.look_at(get_global_mouse_position())

	#Shooting script:
	if Input.is_action_just_pressed('ui_click'):
		shoot()
	
	var axis = get_input_axis()
	#A vector2 is a x and a Y value
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
		$Body.stop()
		$Body.set_frame(1)
	else:
		apply_movement(axis * ACCELERATION * delta)
		if Gun_Drawn == true:
			pass
		else:
			$Body.play("Walk")

	if Input.is_action_just_pressed("ui_0"):
		unequip_everything()

	if Input.is_action_just_pressed("ui_1"):
		draw_gun()

#The kinematic body will move and slide along collisions
	motion = move_and_slide(motion)

func get_input_axis():
	var axis = Vector2.ZERO
#	I'm getting the direction as a boolean (0 or 1) and converting it to an int, which then is inserted into the x/y vector
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
#	Normalizing a vector will make it = 1
	return axis.normalized()

#removing speed?
func apply_friction(amount):
	if motion.length() > amount:
#		dette laver et slags slide, men gem det til biler:
#		motion -= motion.normalized() * amount
#	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
#	Sets a max speed of the player, clamped is part of Godot
	motion = motion.clamped(speed)

func _on_GunTimer_timeout():
	can_shoot = true

func draw_gun():
	$Body.play("DrawGun")
	Gun_Drawn = true

func unequip_everything():
	$Body.play("Walk")
	Gun_Drawn = false

	#Quit Game
	
#	if Input.is_key_pressed(KEY_Q):
#		get_tree().quit()
	
	# Goes where i click
	
#	if Input.is_mouse_button_pressed(BUTTON_right):
#		self.position = get_viewport().get_mouse_position()