extends Area2D

@export_file
var next_scene_path = ""
@export
var is_invisible = false
@export
var spawn_location: Vector2 = Vector2(0,0)
@export
var spawn_direction: Vector2 = Vector2(0,0)
@onready
var sprite = $Sprite
@onready
var anim_player = $AnimationPlayer

var player_entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_invisible:
		sprite.texture = null
	sprite.visible = false
	var player = get_tree().current_scene.get_child(0).get_children().back().get_node("Node2D/Player")
	player.player_entering_door_signal.connect(enter_door)
	player.player_entered_door_signal.connect(close_door)

func enter_door():
	if player_entered:
		anim_player.play("OpenDoor")
	
func close_door():
	if player_entered:
		anim_player.play("CloseDoor")
	
func door_closed():
	if player_entered:
		get_node("/root/SceneManager").transition_to_scene(next_scene_path, spawn_location, spawn_direction)
	
func _on_body_entered(_body):
	player_entered = true


func _on_body_exited(_body):
	player_entered = false
