extends ScrollContainer

var crafting_slot: PackedScene = preload("crafting_slot.tscn")
var queued = false
var inventory = {}

func _ready():
	global.modify_inventory.connect(_on_inventory_modification)

func _on_inventory_modification():
	await RenderingServer.frame_post_draw
	queued = true
	inventory = {}
	for item in global.inventory:
		if inventory.has(item.type):
			inventory[item.type] += item.amount
		else:
			inventory[item.type] = item.amount

func is_recipe_valid(recipe):
	for element in behavior.recipes[recipe]:
		if not inventory.has(element): return false
		if inventory[element] < behavior.recipes[recipe][element]: return false
		return true

func _process(_delta):
	if not queued: return
	queued = false
	
	for node in $Recipes.get_children():
		$Recipes.remove_child(node)
		node.queue_free()
	for recipe in behavior.recipes:
		if not is_recipe_valid(recipe): return
		
		var instance = crafting_slot.instantiate()
		instance.item_texture = load("res://textures/items/" + recipe + ".png")
		instance.item = recipe
		instance.recipe = behavior.recipes[recipe]
		$Recipes.add_child(instance)
