extends CharacterBody2D

signal player_moving_signal
signal player_stopped_signal
signal player_entering_door_signal
signal player_entered_door_signal

const LandingDustEffect = preload("res://LandingDustEffect.tscn")

@export
var walk_speed = 4.0
var jump_speed = 4.0
const TILE_SIZE = 16

@onready
var anim_tree = $AnimationTree
@onready
var anim_state = anim_tree.get("parameters/playback")
@onready
var ray = $RayCast2D
@onready
var ledge_ray = $LedgeRayCast2D
@onready
var door_ray = $DoorRayCast2D
@onready
var shadow = $Shadow
var jumping_over_ledge: bool = false

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection { LEFT, RIGHT, UP, DOWN}

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN
var initial_position = Vector2(0 ,0)
var input_direction = Vector2(0 ,1)
var is_moving = false
var stop_input = false
var percent_moved_to_next_tile = 0.0

func _ready():
	$Sprite.visible = true
	anim_tree.active = true
	shadow.visible = false
	initial_position = position
	anim_tree.set("parameters/Walk/blend_position", input_direction)
	anim_tree.set("parameters/Idle/blend_position", input_direction)
	anim_tree.set("parameters/Turn/blend_position", input_direction)
	
		
func player_spawn(location: Vector2, direction: Vector2):
	input_direction = direction
	position = location
	
	anim_tree.set("parameters/Walk/blend_position", input_direction)
	anim_tree.set("parameters/Idle/blend_position", input_direction)
	anim_tree.set("parameters/Turn/blend_position", input_direction)
		

func _physics_process(delta):
	#print(Engine.get_frames_per_second())
	if player_state == PlayerState.TURNING or stop_input:
		return
	elif is_moving == false:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")) 
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")) 
		
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
	
		var teste = need_to_turn()
		if teste and player_state != PlayerState.WALKING:
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			player_state = PlayerState.WALKING
			anim_state.travel("Walk")
			initial_position = position
			is_moving = true
	else:
		player_state = PlayerState.IDLE
		anim_state.travel("Idle")
		
func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	if input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	if input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	if input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
	
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	facing_direction = new_facing_direction
	return false
		
		
func finished_turning():
	player_state = PlayerState.IDLE
	
func entered_door():
	emit_signal("player_entered_door_signal")
	
						
func move(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	
	ray.target_position  = desired_step
	ray.force_raycast_update()
	ledge_ray.target_position = desired_step
	ledge_ray.force_raycast_update()
	door_ray.target_position = desired_step
	door_ray.force_raycast_update()
	
	if door_ray.is_colliding():
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_entering_door_signal")
			stop_input = true
			$AnimationPlayer.play("Dissapear")
			#$Camera2D.set_enabled(false)	
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
			
		
	elif (ledge_ray.is_colliding() && input_direction == Vector2(0, 1)) or jumping_over_ledge:
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 2.0:
			position = initial_position + (input_direction * TILE_SIZE * 2)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			shadow.visible = false
			jumping_over_ledge = false
			var dust_effect = LandingDustEffect.instantiate()
			dust_effect.position = position
			get_tree().current_scene.get_child(0).get_child(0).add_child(dust_effect)
		else:
			jumping_over_ledge = true
			shadow.visible = true
			var input = input_direction.y * TILE_SIZE * percent_moved_to_next_tile
			position.y = initial_position.y + (-0.96 - 0.53 * input + 0.05 * pow(input, 2))
			
	elif !ray.is_colliding():
		
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_moving_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		is_moving = false
		percent_moved_to_next_tile = 0.0
		
