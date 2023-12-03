extends Area2D

@export var item = "log"
@export var amount = 1

func _on_body_entered(_body):
	if global.pick_up(item, amount):
		hide()
		$AudioStreamPlayer2D.play()
		await $AudioStreamPlayer2D.finished
		queue_free()

func _on_despawn_timer_timeout():
	queue_free()
