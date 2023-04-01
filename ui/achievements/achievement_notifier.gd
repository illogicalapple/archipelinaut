extends RichTextLabel

var format = "[right]achievement made: [b][color=#b0ffca][%s][/color][/b][/right]"

@export var achievement_name = "achievement"

func _ready():
	text = format % achievement_name
	await get_tree().create_timer(3).timeout
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 2)
	tween.tween_callback(queue_free)
