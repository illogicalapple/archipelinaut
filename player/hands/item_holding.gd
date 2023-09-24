extends CharacterBody2D

@export var item: String = "air"

var config_file: ConfigFile = ConfigFile.new()
@export var old_rot = rotation

func _ready(ahh: bool = true):
	if ahh:
		config_file.load("res://behavior/holding_behavior.cfg")
	$Texture.show()
	$Texture.position = config_file.get_value(item, "offset", Vector2(0, 0))
	if config_file.has_section(item):
		$Texture.texture = load("res://textures/items/holding/" + item + ".png")
	else:
		$Texture.hide()

func update_texture():
	item = global.inventory[global.active_id].type
	_ready(false)
