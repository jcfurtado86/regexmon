extends Node2D

var next_scene = null
var player_location = Vector2(0,0)
var player_direction = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass	
	
func transition_to_scene(new_scene : String, spawn_location, spawn_direction):
	next_scene = new_scene
	player_direction = spawn_direction
	player_location = spawn_location
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
func finished_fading():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(next_scene).instantiate())
	
	var player = get_tree().current_scene.get_child(0).get_children().back().get_node("Node2D/Player")
	player.player_spawn(player_location, player_direction)	
	
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")

