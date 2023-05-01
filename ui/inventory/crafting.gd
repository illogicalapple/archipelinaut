extends ScrollContainer

var crafting_slot: PackedScene = preload("crafting_slot.tscn")
var queued = false
var inventory = {}

func _ready():
	global.modify_inventory.connect(_on_inventory_modification)

func _on_inventory_modification():
	print("bleh")
	queued = true
	inventory = {}
	for item in global.inventory:
		if inventory.has(item.type):
			inventory[item.type] += item.amount
		else:
			inventory[item.type] = item.amount

func _on_update_timer_timeout():
	if queued:
		for node in $Recipes.get_children():
			$Recipes.remove_child(node)
			node.queue_free()
		for recipe in behavior.recipes:
			var valid = true
			for element in behavior.recipes[recipe]:
				if inventory.has(element):
					if inventory[element] >= behavior.recipes[recipe][element]:
						pass
					else: valid = false
				else: valid = false
			if valid:
				var instance = crafting_slot.instantiate()
				instance.item_texture = load("res://textures/items/" + recipe + ".png")
				instance.item = recipe
				instance.recipe = behavior.recipes[recipe]
				$Recipes.add_child(instance)
		queued = false
