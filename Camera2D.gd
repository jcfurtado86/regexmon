extends Camera2D

# the size of each tile in the tileset
@export 
var tile_size = Vector2(16, 16)

# the number of tiles in each row and column of the tilemap
@export
var tilemap_size = Vector2(20, 11)

# the margin around the edge of the screen that triggers a screen transition
@export var screen_margin = Vector2(0, 0)

# the position of the current screen
var current_screen = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# set the camera as a top-level node
	#set_as_top_level(true)
	# update the screen position
	#update_screen(current_screen)

# updates the camera position based on the new screen position
func update_screen(new_screen: Vector2):
	current_screen = new_screen
	global_position = current_screen * tile_size * tilemap_size + tile_size * tilemap_size * 0.5

# Called every physics frame.
func _physics_process(_delta):
	pass
	# get the player's position
	#var player_position = get_node("/root/Town/Node2D/Player").global_position
	#var player_position = get_parent().global_position
	
	
	# calculate the player's screen position based on their global position
	#var player_screen = Vector2(
	#	player_position.x / (tile_size.x * tilemap_size.x),
	#	player_position.y / (tile_size.y * tilemap_size.y)
	#).floor()
	
	# check if the player has moved to a different screen
	#if not player_screen.is_equal_approx(current_screen):
	#	update_screen(player_screen)
