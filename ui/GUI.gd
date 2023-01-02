extends CanvasLayer

var paused: bool = false
var health = 100
var loading_progress: float = 0: set = set_loading_progress

func pause(event: InputEvent):
	if event.is_action_pressed("ui_pause"):
		paused = !paused
		if paused:
			get_tree().set_deferred("paused", true)
			$Control/Pause.show()
			$Control/Pause/AnimationPlayer.play("pause")
		else:
			get_tree().paused = false
			$Control/Pause/AnimationPlayer.play_backwards("pause")

func _on_AnimationPlayer_animation_finished(_anim_name):
	if not paused:
		$Control/Pause.hide()

func _ready():
	var hints = $Control/Loading/Hint.get_meta("hints")
	print("bop")
	$Control/Pause.hide()
	$Control/Loading/Hint.text = hints[randi_range(0, len(hints) - 1)]

func _process(delta):
	health += delta / 5
	health = clamp(health, 0, 100)

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
