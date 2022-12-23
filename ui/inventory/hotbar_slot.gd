extends TextureButton

@export var item = "air": set = set_item
@export var id = 0
@export var hotbar_item = false

var active: bool = false: set = set_active
var item_moving: bool = false

@onready var inventory := get_parent().get_parent()

func set_item(new_item):
	if inventory.item_holding.type == "air":
		$TextureRect.texture = load("res://textures/items/" + new_item + ".svg")
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
		if inventory.item_holding.type == "air":
			inventory.item_holding = global.inventory[id]
			global.inventory[id] = global.air
		else:
			var slot_item = global.inventory[id]
			var old_holding = inventory.item_holding
			if slot_item.type != "air":
				inventory.item_holding = slot_item
				item_moving = true
			global.inventory[id] = old_holding
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
	else:
		$TextureRect.position = get_local_mouse_position()
