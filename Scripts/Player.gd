extends "res://Scripts/People.gd"

var ACCELERATION = 6000
var velocity = Vector2.ZERO
onready var parent = get_parent() #Parent should be the root node, otherwise this code needs to be changed to reflect that

onready var health_bar : TextureProgress = parent.get_node("Interface/CanvasLayer/Bars/LifeBar/TextureProgress")
onready var health_bar_label : Label = parent.get_node("Interface/CanvasLayer/Bars/LifeBar/Counter/Label")
onready var store_favor_label : Label = parent.get_node("Interface/CanvasLayer/HBoxContainer/ReputationCounter/Label")

onready var enemy_hitman : KinematicBody2D = $Enemy_Hitman

var store_favor = 0

var Gun_Drawn = false

#Get player direction input
func _physics_process(delta):
	#Body kommer fra people scenen
	$Body.look_at(get_global_mouse_position())

	#Shooting script:
	if Input.is_action_pressed('ui_click'):
		shoot()
	
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
		
		#Animation
		$Body.stop()
		$Body.set_frame(1)
	else:
		apply_movement(axis * ACCELERATION * delta)
		
		# Plays walk animation is fun isn't drawn
		if Gun_Drawn == true:
			pass
		else:
			$Body.play("Walk") #Animation

	if Input.is_action_just_pressed("ui_1"):
		draw_gun()

	if Input.is_action_just_pressed("ui_3"):
		unequip_everything()

#The kinematic body will move and slide along collisions
	velocity = move_and_slide(velocity)

func get_input_axis():
	var axis = Vector2.ZERO
#	I'm getting the direction as a boolean (0 or 1) and converting it to an int, which then is inserted into the x/y vector
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
#	Normalizing a vector will make it = 1
	return axis.normalized()

#removing speed?
func apply_friction(amount):
	if velocity.length() > amount:
#		dette laver et slags slide, men gem det til biler:
#		velocity -= velocity.normalized() * amount
#	else:
		velocity = Vector2.ZERO

func apply_movement(acceleration):
	velocity += acceleration
#	Sets a max speed of the player, clamped is part of Godot
	velocity = velocity.clamped(speed)

func _on_GunTimer_timeout():
	can_shoot = true

func draw_gun():
	$Body.play("DrawGun")
	Gun_Drawn = true

func unequip_everything():
	$Body.play("Walk")
	Gun_Drawn = false

func update_health_bar():
	if health_bar != null:
		health_bar.value = health
	if health_bar_label != null:
		health_bar_label.set_text(str(health,"/100"))

func update_store_favor():
	store_favor += 1
	if store_favor_label != null:
		store_favor_label.set_text(str(store_favor))


func _on_Box_customer_good_experience():
	update_store_favor()


func _on_Box2_customer_good_experience():
	update_store_favor()


func _on_Box3_customer_good_experience():
	update_store_favor()


func _on_Box4_customer_good_experience():
	update_store_favor()


func _on_Box5_customer_good_experience():
	update_store_favor()

func _on_Box6_customer_good_experience():
	update_store_favor()
