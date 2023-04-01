extends Node

func _ready():
	var screen_size = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var points = poisson.generate(100, screen_size, rng, true, 30)
	for point in points:
		global.drop("log", 1, point)
	print(screen_size)
