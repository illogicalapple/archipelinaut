extends CanvasLayer

var paused: bool = false
var health = 100
var loading_progress: float = 0: set = set_loading_progress
var cursor = preload("../cursor.svg")

@onready var parent = get_parent()

func pause(event: InputEvent):
	if not event.is_action_pressed("ui_pause"): return
	
	paused = not paused
	$Control/Pause/Default/Options.open_screen($Control/Pause/Default)
	if paused:
		AudioServer.set_bus_effect_enabled(1, 0, true)
		AudioServer.set_bus_volume_db(1, -7)
		get_tree().set_deferred("paused", true)
		$Control/BGBlur.show()
		Input.set_custom_mouse_cursor(null)
		$Control/Pause.show()
		return
	for child in $Control/Pause/Default/Options.get_children():
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

func _on_player_damage(amount, _show_effect):
	damage(amount)

func set_loading_progress(new_progress):
	loading_progress = new_progress
	$Control/Loading/VBoxContainer/ProgressBar.value = new_progress
	if new_progress >= 99:
		$Control/Loading.hide()
