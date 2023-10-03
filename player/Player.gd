extends CharacterBody2D

# var velocity := Vector2(0, 0)
var in_water: bool = false
var breath_left: float = 20
var dps: float = 0
var mining_ability: float = 1

var item_holding

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
	global.modify_inventory.connect($ItemHolding.update_texture)

func _process(delta):
	velocity += Input.get_vector("move_left_0", "move_right_0", "move_up_0", "move_down_0")
	velocity = velocity.lerp(Vector2(0, 0), delta * 8 * (int(in_water) * 1.1 + 1))
	position += velocity * delta / 0.02
	$ItemHolding.position.x = sign(velocity.x + 0.0000000001) * 15
	$ItemHolding.rotation = $ItemHolding.old_rot * sign(velocity.x + 0.0000000001)
	if in_water:
		dps = 0
		return
	breath_left -= delta
	$Stamina.value = breath_left * 5
	if breath_left <= 0:
		dps = 10
		

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
