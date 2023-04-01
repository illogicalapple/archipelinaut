extends Area2D

var active: bool = false

func _on_mouse_entered():
	active = true
	modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	active = false
	modulate = Color(1, 1, 1) # undo
	$ChopTimer.stop()
	$Health.hide()

func _process(_delta):
	if not $ChopTimer.is_stopped():
		$Health.value = $ChopTimer.time_left * 30

func _input(event):
	if event.is_action_pressed("attack_0") and active:
		$Health.show()
		$ChopTimer.wait_time = 3.0 / get_node("../Player").mining_ability
		$Health.max_value = $ChopTimer.wait_time * 30
		$ChopTimer.start()
	elif event.is_action_released("attack_0") and active:
		$ChopTimer.stop()
		$Health.hide()

func _on_chop_timer_timeout():
	global.drop("log", randi_range(1, 3), position)
	global.achievement("punch_tree")
	queue_free() # DIE YOU DUMB USELESS TREE
