class_name Island extends Area2D

signal generated

var tree_scene: PackedScene = load("res://entities/tree/tree.tscn")
@onready var root = get_node("/root/Root")
var generation_state: int = 0

func generate(_game_seed):
	$IslandGen/Island.get_texture().noise.seed = _game_seed
	$TreeGen/Island.get_texture().noise.seed = $IslandGen/Island.get_texture().noise.seed

func _on_island_gen_ready():
	await RenderingServer.frame_post_draw
	var img = $IslandGen.get_texture().get_image()
	var island_texture = $IslandGen/Island.texture
	await RenderingServer.frame_post_draw
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(img)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	$Sprite2D.texture = island_texture
	for polygon in polygons:
		var collider = CollisionPolygon2D.new()
		collider.polygon = polygon
		add_child(collider)
		$BoatCollisions.add_child(collider.duplicate())
	$IslandGen.queue_free()
	generation_state += 1
	if generation_state == 2: emit_signal("generated")

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
		while(found < ceil(((size.x + size.y) / 200) * 7)):
			var candidate = Vector2(root.rng.randf_range(0, size.x), root.rng.randf_range(0, size.y)) + pos
			if Geometry2D.is_point_in_polygon(candidate, polygon):
				positions.append(candidate)
				found += 1
	for i in range(min(root.rng.randi_range(12, 32), len(positions))):
		if randi_range(0, 3) == 3:
			continue
		var tree_instance = tree_scene.instantiate()
		var rand_index = root.rng.randi_range(0, len(positions) - 1)
		tree_instance.position = positions[rand_index] + position
		positions.remove_at(rand_index)
		root.get_node("Things").add_child(tree_instance)
	$TreeGen.queue_free()
	generation_state += 1
	if generation_state == 2: 
		emit_signal("generated")
