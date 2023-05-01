extends TextureButton

@export var item_texture: Texture2D = preload("res://textures/items/test.png")
@export var item := "test"
@export var recipe := {}

func _ready():
	$TextureRect.texture = item_texture

func _on_pressed():
	global.pick_up(item, 1)
	for aaaaaaa in recipe:
		global.bye(aaaaaaa, recipe[aaaaaaa])
