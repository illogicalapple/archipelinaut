extends RichTextLabel

@onready var dialogue_target: Node = get_parent()

# with the camera logic just for self-documentation :)
@onready var camera_target: Camera2D = get_viewport().get_camera_2d()

## Times a new character is shown every second.
@export var updates_per_second: float = 30

var _text_tw: Tween

## Parses a bbcode input and removes all bbcode tags
func _bbcode_to_plain(bbcode_input):
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(bbcode_input, "", true)

func speak(text_to_speak):
	show()
	$Label.hide()
	visible_characters = 0
	text = text_to_speak
	
	# camera logic
	camera_target = get_viewport().get_camera_2d()
	var cam_tw: Dictionary = {
		"position": get_tree().create_tween(),
		"zoom": get_tree().create_tween()
	}
	
	cam_tw.position.tween_property(camera_target, "global_position", dialogue_target.global_position, 0.3)
	cam_tw.zoom.tween_property(camera_target, "zoom", Vector2(2.0, 2.0), 0.3)
	
	_text_tw = get_tree().create_tween()
	_text_tw.tween_property(self, "visible_characters",
		len(_bbcode_to_plain(text)),
		len(_bbcode_to_plain(text)) / updates_per_second
	)
	_text_tw.finished.connect($Label.show)
	_text_tw.finished.connect($Timer.stop)
	
	$Timer.wait_time = 1 / updates_per_second
	$Timer.start()

func shut_up():
	var cam_tw: Dictionary = {
		"position": get_tree().create_tween(),
		"zoom": get_tree().create_tween()
	}
	cam_tw.position.tween_property(camera_target, "position", Vector2(0, 0), 0.3)
	cam_tw.zoom.tween_property(camera_target, "zoom", Vector2.ONE, 0.3)
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("advance_dialogue"):
		accept_event()
		if $Timer.is_stopped(): shut_up()
		else: _text_tw.custom_step(INF)
