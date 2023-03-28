extends Node2D

@onready
var anim_player = $AnimationPlayer
const grass_overlay_texture = preload("res://Assets/Grass/stepped_tall_grass.png")
const GrassStepEffect = preload("res://GrassStepEffect.tscn")
var grass_overlay: TextureRect = null
var grass_step = null
var player_inside: bool = false

func _ready():
	var player = get_parent().get_parent().get_node("Player")
	player.player_moving_signal.connect(player_exiting_grass)
	player.player_stopped_signal.connect(player_in_grass)
	

func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()
	
func player_in_grass():
	if player_inside == true:
		grass_step = GrassStepEffect.instantiate()
		grass_step.position = position
		get_tree().current_scene.get_child(0).get_child(0).add_child(grass_step)
				
		grass_overlay = TextureRect.new()
		grass_overlay.texture = grass_overlay_texture
		grass_overlay.position = position
		get_tree().current_scene.get_child(0).get_child(0).add_child(grass_overlay)
		

func _on_area_2d_body_entered(_body):
	player_inside = true
	anim_player.play("Stepped")
	
func _on_area_2d_body_exited(_body):
	player_inside = false
	anim_player.play("Idle")
