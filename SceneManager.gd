extends Node2D

var next_scene = null
var player_location = Vector2(0,0)
var player_direction = Vector2(0,0)

enum TransitionType {NEW_SCENE, PARTY_SCREEN, MENU_ONLY}
var transition_type = TransitionType.NEW_SCENE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass	
	
func transition_to_party_screen():
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	transition_type = TransitionType.PARTY_SCREEN

func transition_exit_party_screen():
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	transition_type = TransitionType.MENU_ONLY
	
func transition_to_scene(new_scene : String, spawn_location, spawn_direction):
	next_scene = new_scene
	player_direction = spawn_direction
	player_location = spawn_location
	transition_type = TransitionType.NEW_SCENE
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
func finished_fading():
	match transition_type:
		TransitionType.NEW_SCENE:
			$CurrentScene.get_child(0).queue_free()
			$CurrentScene.add_child(load(next_scene).instantiate())
			
			var player = get_tree().current_scene.get_child(0).get_children().back().get_node("Node2D/Player")
			player.player_spawn(player_location, player_direction)	
		TransitionType.PARTY_SCREEN:
			$Menu.load_party_screen()
		TransitionType.MENU_ONLY:
			$Menu.unload_party_screen()
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")

