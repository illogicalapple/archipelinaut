extends Node

var island := []
var rng := RandomNumberGenerator.new()
var screen_size := Vector2(0, 0)
var game_seed: int
var velocity = Vector2(0, 0)
var tree_scene: PackedScene = load("res://objects/tree/tree.tscn")
var device_id: int = 0
var cursor = load("cursor.svg")

@onready var player = $Things/Player

func island_gen():
	$IslandGen/Island.get_texture().noise.seed = game_seed
	$TreeGen/Island.get_texture().noise.seed = game_seed
	# var bitmap = BitMap.new()
	# bitmap.create_from_image_alpha($Island.material)
	# var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))

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
	island_gen()

func _process(delta):
	$Camera.position = $Camera.position.lerp(player.position - screen_size / 2, delta * 8)

func _on_IslandGen_ready():
	await RenderingServer.frame_post_draw
	var img = $IslandGen.get_texture().get_image()
	var island_texture = ImageTexture.create_from_image(img)
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(img)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	$Island/Sprite2D.texture = island_texture
	for polygon in polygons:
		var collider = CollisionPolygon2D.new()
		collider.polygon = polygon
		$Island.add_child(collider)
	$IslandGen.queue_free()

func _on_tree_gen_ready():
	await RenderingServer.frame_post_draw
	var img: Image = $TreeGen.get_texture().get_image()
	var bitmap = BitMap.new()
	var positions = []
	bitmap.create_from_image_alpha(img)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	for polygon in polygons:
		var polygon_shape = ConcavePolygonShape2D.new()
		polygon_shape.segments = polygon
		var rect = polygon_shape.get_rect()
		var size = rect.size
		var pos = rect.position
		var found = 0.0
		while(found < round(((size.x + size.y) / 200) * 7)):
			var candidate = Vector2(rng.randf_range(0, size.x), rng.randf_range(0, size.y)) + pos
			if Geometry2D.is_point_in_polygon(candidate, polygon):
				positions.append(candidate)
				found += 1
	print(len(positions))
	for i in range(min(rng.randi_range(4, 6), len(positions))):
		var tree_instance = tree_scene.instantiate()
		var rand_index = rng.randi_range(0, len(positions) - 1)
		tree_instance.position = positions[rand_index]
		positions.remove_at(rand_index)
		$Things.add_child(tree_instance)
