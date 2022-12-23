extends CanvasLayer

var elapsed_time: float = 0
var outer_done: bool = false
var anim_done: bool = false
var characters: int = 0
var paused: bool = false
var settings_screen: int = 0
var settings_id = 5
var health = 100

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
	print("bop")
	$Control/Pause.hide()

func _process(delta):
	health += delta / 5
	health = clamp(health, 0, 100)
	$Control/HealthBar.value = health

func _input(event):
	pause(event)

func damage(amount: float, _show_effect: bool = true):
	health -= amount

func _on_player_damage(amount, _show_effect):
	damage(amount)
