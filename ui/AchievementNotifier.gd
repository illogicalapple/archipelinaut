extends VBoxContainer

var notifier_node = preload("res://ui/achievements/achievement_notifier.tscn")

func _ready():
	global.achievement_change.connect(_on_global_achievement_change)

func _on_global_achievement_change(id):
	var notifier = notifier_node.instantiate()
	notifier.achievement_name = global.achievements[id][0]
	add_child(notifier)
