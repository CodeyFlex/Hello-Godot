extends Node2D

# AI Navigation variables (Ikke i brug endnu)
onready var nav_2d : Navigation2D = $Navigation2D
onready var line_2d : Line2D = $Line2D

#NPC's
onready var cashier : KinematicBody2D = $Cashier
onready var enemy_hitman : KinematicBody2D = $Enemy_Hitman

# Camera Variables
onready var map_camera_borders : TileMap = $MapNode2D/ForestTileMap 
onready var player_camera : Camera2D = $Player/Camera2D

#Store variables
onready var box : KinematicBody2D = $StoreNodes/Box4
onready var desk : Position2D = $MapNode2D/CashierPosition

#Hospital Variables
onready var healing_station : KinematicBody2D = $MapNode2D/Healing_Station

#Creates a path to target position
func path_finder(actor, target_position):
	var new_path : = nav_2d.get_simple_path(actor.global_position, target_position.global_position, false)
	line_2d.points = new_path
	actor.path = new_path

func _ready():
	set_camera_limits()

func _process(delta):
	pass

func cashier_pathfinding():
	if cashier == null:
		return
	#Checks if a box is empty and if it's empty walks to it
	if box.get_current_stock() == 0:
		path_finder(cashier, box)
	#If no box is empty, returns to desk
	elif box.get_current_stock() != 0:
		path_finder(cashier, desk)

func enemy_hitman_pathfinding():
	if enemy_hitman != null:
		if enemy_hitman.get_npc_health() < (enemy_hitman.get_npc_max_health() / 2):
			path_finder(enemy_hitman, healing_station)

func set_camera_limits():
	var map_limits = map_camera_borders.get_used_rect()
	var map_cellsize = map_camera_borders.cell_size
	player_camera.limit_left = map_limits.position.x * map_cellsize.x
	player_camera.limit_right = map_limits.end.x * map_cellsize.x
	player_camera.limit_top = map_limits.position.y * map_cellsize.y
	player_camera.limit_bottom = map_limits.end.y * map_cellsize.y

#Shooting script for spawning bullets
func _on_EnemyHitman_shoot(bullet, _position, _direction, shooter):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, shooter)

#Shooting script for spawning bullets
func _on_Player_shoot(bullet, _position, _direction, shooter):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction, shooter)

func _on_Cashier_no_path():
	cashier_pathfinding()

func _on_Enemy_Hitman_no_path():
	enemy_hitman_pathfinding()
