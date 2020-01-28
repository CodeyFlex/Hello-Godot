extends Node2D

#To stop camera from going out of bounds leaving the player

func _ready():
	set_camera_limits()
	
	#ForestTileMap er navnet på tilemap
#	Burde muligvis ændres til et mere fundamentalt tilemap som ikke kun er skoven.
func set_camera_limits():
	var map_limits = $ForestTileMap.get_used_rect()
	var map_cellsize = $ForestTileMap.cell_size
	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	
#Shooting script below, eftersom skudende bliver skabt i map

func _on_EnemyHitman_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)