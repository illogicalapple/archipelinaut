extends CharacterBody2D

@export var speed: float = 200
@export var min_distance: float = 50
@onready var player = get_parent().get_node("Player")

var screen_size: Vector2
var spinning: bool = false
var target: Vector2
var pause_timer: SceneTreeTimer : set = _set_pause_timer
var movable: bool = true

func move_by(amount: Vector2):
	scale.x = -1 if amount.x < 0 else 1
	position += amount

func _set_pause_timer(new_pause_timer):
	pause_timer = new_pause_timer
	movable = false
	await pause_timer.timeout
	movable = true

func _ready():
	screen_size = get_viewport_rect().size
	position += screen_size / 2

func _unhandled_input(event):
	if event.is_action_pressed("friend_spin!!!") and !spinning:
		global.achievement("friend_spin")
		spinning = true
		$SPINANIMATION.play("friend_spin!!!")

func _on_spinanimation_animation_finished(_anim_name):
	if Input.is_action_pressed("friend_spin!!!"):
		$SPINANIMATION.play("friend_spin!!!")
	else:
		spinning = false
		$SPINANIMATION.stop()

func _process(delta):
	if position.distance_to(player.position) > min_distance:
		target = player.position
		move_by((player.position - position).normalized() * speed * delta)
		return
		
	if position.distance_to(target) < 50:
		var radians = randf_range(0, PI * 2)
		target = player.position + Vector2(cos(radians), sin(radians)) * randf_range(0, min_distance)
		pause_timer = get_tree().create_timer(randf_range(2.0, 5.0))
	if movable:
		move_by((target - position).normalized() * speed * delta / 2.5)
