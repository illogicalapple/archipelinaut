extends Node

var island := []
var rng := RandomNumberGenerator.new()
var screen_size := Vector2(0, 0)
var game_seed: int
var velocity = Vector2(0, 0)

var device_id: int = 0

@onready var player = $Player

func island_gen():
	$IslandGen/Island.get_texture().noise.seed = game_seed
	# var bitmap = BitMap.new()
	# bitmap.create_from_image_alpha($Island.material)
	# var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))

func _ready():
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
