extends Node

var item_scene = preload("objects/item.tscn")
var air = {
	"type": "air",
	"amount": 1
}
var inventory: Array = [
	air, air, air, air, air,
	air, air, air, air, air,
	air, air, air, air, air,
	air, air, air, air, air
] # very empty inventory

func pick_up(item, amount):
	var open_slot = inventory.find(air)
	var stack_slot = -1
	for i in inventory:
		if i.type == item:
			stack_slot = inventory.find(i)
	if stack_slot == -1:
		if open_slot == -1:
			return false
		else:
			inventory[open_slot] = {
				"type": item,
				"amount": amount
			}
			return true
	else:
		inventory[stack_slot].amount += amount
		return true

func _unhandled_input(event):
	if event.is_action_pressed("inventory_0"):
		pick_up("test", 1)

func drop(item, amount, pos):
	var item_instance = item_scene.instantiate()
	item_instance.item = item
	item_instance.amount = amount
	item_instance.position = pos
	get_tree().get_root().get_node("Root/Things").add_child(item_instance)
