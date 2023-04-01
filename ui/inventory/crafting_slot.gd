extends TextureButton

@export var item_texture: Texture2D = preload("res://textures/items/test.png")

func _ready():
	$TextureRect.texture = item_texture
