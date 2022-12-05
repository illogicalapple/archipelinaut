extends Node

var island := []
var rng := RandomNumberGenerator.new()
var screen_size := Vector2(0, 0)
var game_seed: int
var velocity = Vector2(0, 0)

var device_id: int = 0

const max_size = 150

func island_gen(max_distance):
	$Island.get_texture().noise.seed = game_seed

func _ready():
	randomize()
	game_seed = randi() # change to a seed setting later
	screen_size = get_viewport().get_visible_rect().size
	island_gen(max_size)

func _process(delta):
	velocity += Vector2(int(Input.is_action_pressed("move_right_" + str(device_id))) - int(Input.is_action_pressed("move_left_" + str(device_id))), int(Input.is_action_pressed("move_down_" + str(device_id))) - int(Input.is_action_pressed("move_up_" + str(device_id)))).normalized()
	velocity *= 0.97
	$Player.position += velocity * delta / 0.033
	$Camera.position += ($Player.position - $Camera.position) / 25
