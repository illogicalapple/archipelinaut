extends TextureButton

@export var inventory_path: NodePath
@export var item = "air": set = set_item
@export var id = 0
@export var hotbar_item = false

@onready var inventory: VBoxContainer = get_node(inventory_path)

var active: bool = false: set = set_active
var item_moving: bool = false : set = set_item_moving

func set_item(new_item):
	if inventory.item_holding.type == "air":
		$TextureRect.texture = load("res://textures/items/" + new_item + ".png")
	item = new_item

func set_active(new_active):
	if hotbar_item:
		active = new_active
		if active:
			$Selected.show()
		else:
			$Selected.hide()

func _on_pressed():
	if inventory.inventory_open:
		pass
	elif hotbar_item:
		inventory.active_id = id

func _ready():
	if not hotbar_item:
		texture_normal = load("ui/inventory/square.svg")

func _process(_delta):
	item = global.inventory[id].type
	if not item_moving:
		if global.inventory[id].type == "air":
			$Amount.hide()
		else:
			$Amount.show()
			$Amount.text = str(global.inventory[id].amount)

func set_item_moving(new_item_moving):
	if new_item_moving: inventory.id_moving = id
	item_moving = new_item_moving
