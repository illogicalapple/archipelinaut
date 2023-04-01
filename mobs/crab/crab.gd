extends Node2D

@export var speed = 150
@export var health = 100
@export var jump_velocity = 400

var velocity: float = 0
var angry_texture := preload("crab-angry.svg")
var angry: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var movement_vector: Vector2

func _ready():
	pass

func _process(delta):
	$Crab.position.y = min($Crab.position.y - velocity * delta, 0)
	if $Crab.position.y < 0:
		velocity -= gravity / 5
		position += movement_vector * delta
	else:
		var movement_angle = randf_range(0, PI * 2)
		velocity = jump_velocity
		movement_vector = Vector2(cos(movement_angle), sin(movement_angle)) * speed
