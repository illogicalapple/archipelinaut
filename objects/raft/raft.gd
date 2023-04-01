extends RigidBody2D

func _input(event):
	if event.is_action_pressed("move_left_0"):
		move_and_collide(Vector2(-10, 0))
