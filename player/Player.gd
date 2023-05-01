extends CharacterBody2D

# var velocity := Vector2(0, 0)
var in_water: bool = false
var breath_left: float = 20
var dps: float = 0
var mining_ability: float = 1

const device_id: int = 0

signal damage(amount: float, show_effect: bool)

@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var root: Node = get_parent().get_parent()

@export var water_texture = Texture2D.new()
@export var land_texture = Texture2D.new()

func in_water_once():
	in_water = not $Hurtbox.overlaps_area(root.get_node("Islands/Island"))
	if in_water:
		$Sprite.texture = water_texture
	else:
		$Sprite.texture = land_texture
		$Stamina.hide()

func _ready():
	position += screen_size / 2
	call_deferred("in_water_once")

func _process(delta):
	velocity += Vector2(int(Input.is_action_pressed("move_right_" + str(device_id))) - int(Input.is_action_pressed("move_left_" + str(device_id))), int(Input.is_action_pressed("move_down_" + str(device_id))) - int(Input.is_action_pressed("move_up_" + str(device_id)))).normalized() * delta * 50
	velocity = velocity.lerp(Vector2(0, 0), delta * 4 * (int(in_water) * 3 + 1))
	position += velocity * delta / 0.02
	if in_water:
		breath_left -= delta
		$Stamina.value = breath_left * 5
		if breath_left <= 0:
			dps = 10
	else:
		dps = 0

func _on_Hurtbox_area_entered(area):
	if area.name.contains("Island"):
		$Stamina.hide()
		$Sprite.texture = land_texture
		in_water = false

func _on_Hurtbox_area_exited(area):
	if area.name.contains("Island"):
		$Stamina.show()
		$Stamina.value = 100
		$Sprite.texture = water_texture
		breath_left = 20
		in_water = true

func _on_dps_timeout():
	emit_signal("damage", dps / 2.0, true)

func _input(event): # DEBUG
	if event.is_action_pressed("hotbar_4"):
		_on_Hurtbox_area_entered(root.get_node("Islands/Island"))
