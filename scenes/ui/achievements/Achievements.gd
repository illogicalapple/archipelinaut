extends VBoxContainer

var achievement_scene: PackedScene = preload("res://scenes/ui/achievements/achievement.tscn")

func _ready():
	for achievement in global.achievements:
		var node = achievement_scene.instantiate()
		var thing = global.achievements[achievement]
		node.name = achievement
		node.title = thing[0]
		node.description = thing[1]
		node.texture = load("res://textures/ui/achievements/" + achievement + ".png")
		add_child(node)
