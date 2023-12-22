extends VBoxContainer

signal holding_changed(new_item)

var active_id = 0: set = set_active_hotbar_id
var inventory_open = false
var item_holding = {
	"type": "air",
	"amount": 1
}
var id_moving = -1

func slot(slot_id):
	return get_node("Hotbar/Slot" + str(slot_id))

func set_active_hotbar_id(new_active_id):
	slot(active_id).active = false
	slot(new_active_id).active = true
	active_id = new_active_id
	global.active_id = active_id

func _unhandled_input(event):
	if item_holding.type == "air":
		if event.is_action_pressed("inventory_0"):
			inventory_open = not inventory_open
			$Top.visible = inventory_open
			return
		for i in range(5):
			if event.is_action_pressed("hotbar_" + str(i)):
				active_id = i
				item_in_hand_changed()
				return

func item_in_hand_changed():
	holding_changed.emit(global.inventory[active_id])

func _ready():
	global.modify_inventory.connect(item_in_hand_changed)
	$Top.hide()
	active_id = 0
