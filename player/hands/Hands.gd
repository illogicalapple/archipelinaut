extends StaticBody2D

func _process(_delta):
	if get_parent().in_water:
		hide()
	else:
		show()
	if Input.is_action_pressed("attack_0"):
		$AnimationPlayer.play("punch")
	else:
		$AnimationPlayer.stop()
		rotation = 0
