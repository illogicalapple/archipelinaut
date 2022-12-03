extends Node

var island := []
var rng := RandomNumberGenerator.new()
var screen_size := Vector2(0, 0)
var game_seed: int

const max_size = 150

func island_gen(max_distance):
	$Island.get_texture().noise.seed = game_seed

func _ready():
	randomize()
	game_seed = randi() # change to a seed setting later
	screen_size = get_viewport().get_visible_rect().size
	island_gen(max_size)
	# $Camera.zoom = Vector2(40, 40)
	# $Camera.offset = Vector2(screen_size.x / 2 + 500, screen_size.y / 2 + 500)
