extends HBoxContainer
class_name Achievement

@export var texture: Texture2D = preload("res://textures/ui/achievements/default.svg") # static typed so it doesn't have to be a compressedtexture
@export var title = "achievement"
@export var description = "some things"
@export var completed = false: set = _set_completed

var unknown_texture = preload("res://textures/ui/achievements/unknown.png")

func _ready():
	_set_completed(completed)
	$VBoxContainer/Title.text = title
	global.achievement_change.connect(_on_achievement_change)

func _set_completed(new_value):
	completed = new_value
	if new_value:
		$VBoxContainer/Description.text = description
		$TextureRect.texture = texture
	else:
		$VBoxContainer/Description.text = "?".repeat(len(description))
		$TextureRect.texture = unknown_texture

func _on_achievement_change(id):
	if id == name:
		completed = true
