extends Node

signal achievement_change(name: String)
signal modify_inventory

var item_scene = preload("../entities/item.tscn")
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

var achievements = { # [NAME, DESCRIPTION, COMPLETED?]
	"punch_tree": ["boxer's fracture", "punch a tree", false],
	"friend_spin": ["the duck dance", "make your FRIEND SPIN", false],
	"play_mayo": ["\"is mayonnaise an instrument?\"", "yes, it is. (acquire mayonnaise)", false],
	"wood_sword": ["excalibrrrrr", "craft a wooden sword", false]
}

var active_id: int:
	set(aaa):
		active_id = aaa
		modify_inventory.emit()

func achievement(id):
	if(achievements[id][2]): return
	achievements[id][2] = true
	emit_signal("achievement_change", id)

func bye(item, amount):
	var i1 = 0
	for i in inventory:
		if i.type == item:
			if i.amount > amount:
				i.amount -= amount
				emit_signal("modify_inventory")
				return true
			if i.amount == amount:
				inventory[i1] = air
				emit_signal("modify_inventory")
				return true
		i1 += 1
	return false

func pick_up(item, amount):
	var open_slot = inventory.find(air)
	var stack_slot = -1
	if(item == "mayo"): achievement("play_mayo")
	if item == "wood_sword": achievement("wood_sword")
	for i in inventory:
		if i.type == item:
			stack_slot = inventory.find(i)
	if stack_slot != -1:
		inventory[stack_slot].amount += amount
		emit_signal("modify_inventory")
		return true
	if open_slot == -1:
		return false
	else:
		inventory[open_slot] = {
			"type": item,
			"amount": amount
		}
		emit_signal("modify_inventory")
		return true

func drop(item, amount, pos):
	var item_instance = item_scene.instantiate()
	item_instance.item = item
	item_instance.amount = amount
	item_instance.position = pos
	get_tree().get_root().get_node("Root/Things").add_child(item_instance)
