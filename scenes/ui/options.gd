extends VBoxContainer

func tween(node, property, new_value, duration):
	var thing = get_tree().create_tween()
	thing.set_ease(Tween.EASE_IN_OUT)
	thing.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	thing.tween_property(node, property, new_value, duration)

func open_screen(screen: Control):
	for child in get_parent().get_parent().get_children():
		child.hide()
	screen.show()

func _on_settings_mouse_entered():
	tween($Settings, "theme_override_font_sizes/font_size", 70, 0.1)

func _on_achievements_mouse_entered():
	tween($Achievements, "theme_override_font_sizes/font_size", 70, 0.1)

func _on_quit_mouse_entered():
	tween($Quit, "theme_override_font_sizes/font_size", 70, 0.1)

func _on_settings_mouse_exited():
	tween($Settings, "theme_override_font_sizes/font_size", 56, 0.1)

func _on_achievements_mouse_exited():
	tween($Achievements, "theme_override_font_sizes/font_size", 56, 0.1)

func _on_quit_mouse_exited():
	tween($Quit, "theme_override_font_sizes/font_size", 56, 0.1)

func _on_achievements_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		_on_achievements_mouse_exited()
		open_screen(get_parent().get_parent().get_node("Achievements"))
