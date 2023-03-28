extends StaticBody2D

var trees = preload("res://Assets/SERENE_VILLAGE_REVAMPED/trees.png")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var my_random_number = rng.randf_range(0, 4)
	$Sprite.frame = my_random_number
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
