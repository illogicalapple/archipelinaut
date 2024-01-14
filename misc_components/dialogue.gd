extends RichTextLabel

@onready var dialogue_target: Node = get_parent()
@onready var camera_target: Camera2D = get_viewport().get_camera_2d()

func _bbcode_to_plain(bbcode_input):
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(bbcode_input, "", true)

func speak(text_to_speak):
	show()
	$Label.hide()
	visible_characters = 0
	text = text_to_speak
	
	var text_tw = get_tree().create_tween()
	text_tw.custom_step(1 / 30)
	text_tw.tween_property(self, "visible_characters", len(_bbcode_to_plain(text)), len(_bbcode_to_plain(text)) / 30)
	text_tw.finished.connect($Label.show)
	text_tw.step_finished.connect($AudioStreamPlayer.play)
