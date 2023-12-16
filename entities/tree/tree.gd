extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var sine_offset: float = randf_range(0, 1)

var active: bool = false

func _on_mouse_entered():
	if overlaps_area(player.get_node("Reach")):
		active = true
		modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	active = false
	modulate = Color(1, 1, 1) # undo
	$ChopTimer.stop()
	$Health.hide()
	$PunchSFX.stop()


func _process(_delta):
	$Sprite2D.skew = sin(Time.get_ticks_msec() * 0.0008 + sine_offset) * 0.15
	if not $ChopTimer.is_stopped():
		$Health.value = $ChopTimer.time_left * 30

func _input(event):
	if event.is_action_pressed("attack_0") and active:
		if overlaps_area(player.get_node("Reach")):
			$PunchSFX.play()
			$Health.show()
			$ChopTimer.wait_time = 3.0 / player.mining_ability
			$Health.max_value = $ChopTimer.wait_time * 30
			$ChopTimer.start()
	elif event.is_action_released("attack_0"):
		$PunchSFX.stop()
		$ChopTimer.stop()
		$Health.hide()

func _on_chop_timer_timeout():
	$PunchSFX.stop()
	player.reload_reach()
	global.drop("log", randi_range(1, 3), position)
	global.achievement("punch_tree")
	modulate = Color.TRANSPARENT
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	queue_free() # DIE YOU DUMB USELESS TREE


func _on_punch_sfx_finished():
	$PunchSFX.pitch_scale = randf_range(0.8, 1.2)
	$PunchSFX.play()
