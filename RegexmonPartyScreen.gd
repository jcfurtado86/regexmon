extends Node2D

enum Options {
	FIRST_SLOT,
	SECOND_SLOT,
	THIRD_SLOT,
	FOURTH_SLOT,
	FIFTH_SLOT,
	SIXTH_SLOT,
	CANCEL
}
var selected_option: int = Options.FIRST_SLOT

@onready var options: Dictionary = {
	Options.FIRST_SLOT: $FirstRegexmonSlot/Background,
	Options.SECOND_SLOT: $SecondRegexmonSlot/Background,
	Options.THIRD_SLOT: $ThirdRegexmonSlot/Background,
	Options.FOURTH_SLOT: $FourthRegexmonSlot/Background,
	Options.FIFTH_SLOT: $FifthRegexmonSlot/Background,
	Options.SIXTH_SLOT: $SixthRegexmonSlot/Background,
	Options.CANCEL: $CancelSprite,
}

func unset_active_option():
	options[selected_option].frame = 0

func set_active_option():
	print(selected_option, options[selected_option])
	options[selected_option].frame = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_active_option()

func _input(event):
	if event.is_action_pressed("ui_down"):
		unset_active_option()
		selected_option = (selected_option+1) % 7
		set_active_option()
	elif event.is_action_pressed("ui_up"):
		unset_active_option()
		if selected_option == 0:
			selected_option = Options.CANCEL
		else:
			selected_option -= 1
		set_active_option()
	elif event.is_action_pressed("ui_left"):
		unset_active_option()
		selected_option = 0
		set_active_option()
	elif event.is_action_pressed("ui_right") and selected_option == Options.FIRST_SLOT:
		unset_active_option()
		selected_option = 1
		set_active_option()
	elif event.is_action_pressed("z"):
		match selected_option:
			Options.CANCEL:
				get_node("/root/SceneManager").transition_exit_party_screen()
