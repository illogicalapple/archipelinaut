extends VBoxContainer

var active_id = 0: set = set_active_hotbar_id
var inventory_open = false
var item_holding = {
	"type": "air",
	"amount": 1
}

func slot(slot_id):
	return get_node("Hotbar/Slot" + str(slot_id))

func set_active_hotbar_id(new_active_id):
	slot(active_id).active = false
	slot(new_active_id).active = true
	active_id = new_active_id

func _unhandled_input(event):
	if item_holding.type == "air":
		if event.is_action_pressed("inventory_0"):
			inventory_open = not inventory_open
			$Inventory.visible = inventory_open
			return
		for i in range(5):
			if event.is_action_pressed("hotbar_" + str(i)):
				active_id = i
				return

func _ready():
	active_id = 0
