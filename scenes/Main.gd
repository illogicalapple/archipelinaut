extends Node

var island: PackedScene = load("res://island/island.tscn")
var rng := RandomNumberGenerator.new()
var screen_size := Vector2(0, 0)
var game_seed: int
var velocity = Vector2(0, 0)
var device_id: int = 0
var cursor = load("cursor.svg")
var island_gen_done: bool = false
var chunk_size: Vector2 = Vector2(1500, 1500) # must be square

@onready var player = $Things/Player

func to_vector2(x: int, y: int):
	return Vector2(x, y) * (chunk_size.x + 750)

func chunk_at(offset: Vector2, weight: float = 100.0):
	var points = poisson.generate(500, chunk_size, rng, true, 30)
	var index = 1
	island_gen_done = true
	for point in points:
		var island_instance = island.instantiate()
		island_instance.position = (point - screen_size / 2) * 10 + offset
		$Islands.add_child(island_instance)
		island_instance.island_gen(0)
		await island_instance.generated
		$GUI.loading_progress += weight / float(len(points) - 1)
		index += 1

func get_polygon_area(polygon):
	var size = polygon.size()
	var area = 0.0
	for i in size:
		var j = (i + 1) % size
		area += abs(polygon[i].x * polygon[j].y - polygon[j].x * polygon[i].y)
	return area / 2.0

func _ready():
	Input.set_custom_mouse_cursor(cursor, 0, Vector2(16, 16))
	randomize()
	game_seed = randi() # change to a seed setting later
	screen_size = get_viewport().get_visible_rect().size

func _process(delta):
	if not island_gen_done:
		await chunk_at(Vector2.ZERO, 20)
		await chunk_at(to_vector2(1, 0), 20)
		await chunk_at(to_vector2(-1, 0), 20)
		await chunk_at(to_vector2(0, 1), 20)
		await chunk_at(to_vector2(0, -1), 20)
	$Camera.position = $Camera.position.lerp(player.position - screen_size / 2, delta * 8)
