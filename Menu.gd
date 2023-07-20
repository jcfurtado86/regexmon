extends CanvasLayer

const RegexmonPartyScreen = preload("res://RegexmonPartyScreen.tscn")

@onready var select_arrow = $Control/NinePatchRect/TextureRect
@onready var menu = $Control

enum ScreenLoaded {NOTHING, JUST_MENU, PARTY_SCREEN}
var screen_loaded = ScreenLoaded.NOTHING
var selected_option: int = 0

func move_arrow():
	select_arrow.position.y = 6 + (selected_option % 6) * 15

func _ready():
	menu.visible = false
	move_arrow()
	
	
func load_party_screen():
	menu.visible = false
	screen_loaded = ScreenLoaded.PARTY_SCREEN
	var party_screen = RegexmonPartyScreen.instantiate(	)
	add_child(party_screen)
	
func unload_party_screen():
	menu.visible = true
	screen_loaded = ScreenLoaded.JUST_MENU
	remove_child($RegexmonPartyScreen)
		
func _unhandled_input(event):
	var player = get_tree().current_scene.get_child(0).get_children().back().get_node("Node2D/Player")
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu"):
				player.set_physics_process(false)
				menu.visible = true
				screen_loaded = ScreenLoaded.JUST_MENU
		ScreenLoaded.JUST_MENU:
			if event.is_action_pressed("menu"):
				player.set_physics_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
			elif event.is_action_pressed("ui_down"):
				selected_option += 1
				move_arrow()
			elif event.is_action_pressed("ui_up"):
				if selected_option == 0:
					selected_option = 5
				else:
					selected_option -= 1
				move_arrow()
			elif event.is_action_pressed("z"):
				get_parent().transition_to_party_screen()
				
		ScreenLoaded.PARTY_SCREEN:
			if event.is_action_pressed("menu"):
				get_parent().transition_exit_party_screen()
			
