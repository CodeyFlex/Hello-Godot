extends KinematicBody2D

signal shoot
#signal health_changed
#signal dead

#These are sent to each child node to be filled in
export(PackedScene) var Bullet
#export (String) var character_name
#maybe add a max speed
export (int) var speed
#export (float) var rotation_speed
export (float) var gun_cooldown
export (int) var health setget set_npc_health, get_npc_health
export (int) var max_health = 100 setget set_npc_max_health, get_npc_max_health

signal no_path

#Path finder
var path : = PoolVector2Array() setget set_path
var path_available = false

#Setters
func set_npc_health(new_value):
	health = new_value

func set_npc_max_health(new_value):
	max_health = new_value

#Getters
func get_npc_health():
	return health

func get_npc_max_health():
	return max_health

#Constants are variables that are assigned once and become permanent.
#Write these in full caps to differentiate.
#const MAXIMUM_RUN_SPEED : = 400

#status variables
#Lav inventory quick slots så man klikker 1, 2, 3 osv. for at vælge våben.
#Array under her:
#var inventoryQuickSlots : = [nothing, fist, gun, knife]
var _velocity = Vector2()
var can_shoot = true
var alive = true

func _ready():
	pass

func control(delta):
	pass
#	$GunTimer.wait_time = gun_cooldown

func shoot():
	if can_shoot:
#		$GunTimer.start()
		var dir = Vector2(1, 0).rotated($Body.global_rotation)
		var shooter = $Body.get_parent()
		emit_signal('shoot', Bullet, $Body/Muzzle.global_position, dir, shooter)

func _on_GunTimer_timeout():
	can_shoot = true

func _physics_process(delta):
	if not alive:
		return
#	control(delta)
#	move_and_slide(_velocity)

	if path_available == false:
		emit_signal("no_path")

	#Max health
	if health > max_health:
		health = max_health
	
	#Die
	if health <= 0:
		die()
	#	animation_player.play('die')

func set_path(value : PoolVector2Array) -> void: #Path is received from root script
	path = value
	if value.size() == 0:
		return
	path_available = true

func move_along_path(distance : float) -> void:
	var last_point : = position
	for index in range(path.size()):
		var distance_to_next : = last_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			#Linear interpolate from Vector2, allows us to find a position between two vectors/positions.
			position = last_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif path.size() == 1 && distance >= distance_to_next:
			position = path[0]
			path_available = false
			break
		distance -= distance_to_next
		last_point = path[0]
		path.remove(0) 

func take_damage(amount:int) -> void:
	health -= amount
	health = max(0, health) #Picks the highest value of the two as the final value.

func heal(amount:int) -> void:
	health += amount
	health = min(health, max_health)
	
#Removes scene instance from game
func die():
	queue_free()
