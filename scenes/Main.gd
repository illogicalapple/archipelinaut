extends Node

var island := []
var rng := RandomNumberGenerator.new()
var screen_size := Vector2(0, 0)
var game_seed: int

const max_size = 150

func island_gen(max_distance):
	pass

func _ready():
	game_seed = randi() # change to a seed setting later
	screen_size = get_viewport().get_visible_rect().size
	island_gen(max_size)
