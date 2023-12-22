extends TextureButton

@export var item_texture: Texture2D = preload("res://textures/items/test.png")
@export var item := "test"
@export var recipe := {}

func _ready():
	$TextureRect.texture = item_texture

func _on_pressed():
	global.pick_up(item, 1)
	for aaaaaaa in recipe:
		global.bye(aaaaaaa, recipe[aaaaaaa])

func _process(delta):
	$Information.position = get_local_mouse_position()

func _on_mouse_entered():
	var readable_recipe = ""
	for item in recipe:
		var append = "s\n"
		if recipe[item] == 1: append = "\n"
		readable_recipe += str(recipe[item]) + " " + item + append
	$Information.text = "[b][color=7EE3A0]{name}[/color][/b]\nrequires:\n{recipe}".format({
		"name": behavior.info[item].name,
		"recipe": readable_recipe.trim_suffix("\n")
	})
	$Information.show()


func _on_mouse_exited():
	$Information.hide()
