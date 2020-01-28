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
export (int) var health
#export (int) var max_health = 100

#Constants are variables that are assigned once and become permanent.
#Write these in full caps to differentiate.
#Writing : = lets godot figure out what type the value is.
#const MAXIMUM_RUN_SPEED : = 400

#status variables
#Lav inventory quick slots så man klikker 1, 2, 3 osv. for at vælge våben.
#Array under her:
#var inventoryQuickSlots : = [nothing, fist, gun, knife]
#var velocity = Vector2()
var can_shoot = true
#var alive = true

func _ready():
	pass

func control(delta):
	$GunTimer.wait_time = gun_cooldown

func shoot():
	if can_shoot:
#		can_shoot = false
#		$GunTimer.start()
		var dir = Vector2(1, 0).rotated($Body.global_rotation)
		emit_signal('shoot', Bullet, $Body/Muzzle.global_position, dir)

func _on_GunTimer_timeout():
	can_shoot = true

#func _physics_process(delta):
#	if not alive:
#		return
#	control(delta)
#	move_and_slide(velocity)

#Tilføj på et tidspunkt:

#Max health
#if health > max_health:
#	health = max_health

#func take_damage(amount:int) -> void:
#	health -= amount
#	health = max(0, health)

#func heal(amount:int) -> void:
#	health += amount
#	health = min(health, max_health)

#Die
#elif health <= 0:
#	die()

#Afspil death animation.
#if health <= 0:
#	animation_player.play('die')