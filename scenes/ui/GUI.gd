extends CanvasLayer

var paused: bool = false
var health = 100
var loading_progress: float = 0: set = set_loading_progress
var cursor = preload("res://textures/ui/cursor.svg")

@onready var parent = get_parent()

func pause(event: InputEvent):
	if not event.is_action_pressed("ui_pause"): return
	
	if not %Options.screen_open == %Default:
		%Options.open_screen(%Default)
		$SFXBack.play()
		return
	
	paused = not paused
	
	if paused:
		AudioServer.set_bus_effect_enabled(1, 0, true) # low pass filter
		AudioServer.set_bus_volume_db(1, -7)
		get_tree().set_deferred("paused", true)
		$Control/BGBlur.show()
		Input.set_custom_mouse_cursor(null)
		$Control/Pause.show()
		return
		
	for child in %Options.get_children():
		if not child is Label: break
		(child as Label).add_theme_font_size_override("font_size", 56)
	$Control/BGBlur.hide()
	AudioServer.set_bus_effect_enabled(1, 0, false)
	AudioServer.set_bus_volume_db(1, -5)
	get_tree().paused = false
	$Control/Pause.hide()
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16, 16))

func _ready():
	var hints = $Control/Loading/Hint.get_meta("hints")
	# $Control/Loading.show()
	$Control/Pause.hide()
	$Control/Loading/Hint.text = hints[randi_range(0, len(hints) - 1)]

func _process(delta):
	health += delta / 5
	health = clamp(health, 0, 100)
	$Control/Health.value = health

func _input(event):
	pause(event)

func damage(amount: float, _show_effect: bool = true):
	health -= amount

func _on_player_deamage(amount, _show_effect):
	damage(amount)

func set_loading_progress(new_progress):
	loading_progress = new_progress
	$Control/Loading/VBoxContainer/ProgressBar.value = new_progress
	if new_progress >= 99:
		$Control/Loading.hide()


func _on_commands_gui_input(event: InputEvent):
	if event.is_action_pressed(""):
		var text: Array[String] = ($Control/Commands.text as String).split(" ")
		if text[0] == "give":
			global.pick_up(text[1], text[2])
		$Control/Commands.clear()
