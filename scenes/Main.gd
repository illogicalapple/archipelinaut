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
	var island_instance = island.instantiate()
	island_instance.position = Vector2.ZERO
	$Islands.add_child(island_instance)
	island_instance.island_gen(0)
	print("waiting for generation")
	await island_instance.generated
	print("generation done!")
	$GUI.loading_progress += 100

func _process(delta):
	$Camera.position = $Camera.position.lerp(player.position - screen_size / 2, delta * 8)
	print(player.get_viewport_transform())
