extends CharacterBody2D

@onready var root = get_parent().get_parent()
var ticks = 0

func _process(_delta):
	ticks += 1
	if ticks > 1 and not visible: queue_free()

func _ready():
	hide()

func _on_hurtbox_area_entered(area):
	if area is Island: show()
