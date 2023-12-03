extends CharacterBody2D

# var velocity := Vector2(0, 0)
var in_water: bool = false
var breath_left: float = 10
var dps: float = 0
var mining_ability: float = 1
var footsteps_playing: bool = false
var walk_sfx: Dictionary = {
	"grass": preload("res://sound/sfx/grasswalk2sfx.mp3"),
	"water": preload("res://sound/sfx/walkwater2sfx.wav")
}

var item_holding

const device_id: int = 0

signal damaged(amount: float, show_effect: bool)

@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var root: Node = get_parent().get_parent()

@export var water_texture = Texture2D.new()
@export var land_texture = Texture2D.new()


# CACHED NODES
# Nodes cached so that it will not need to constantly get it
# any time it needs to be used, instead it's all here.

@onready var Sprite : Sprite2D = $Sprite
@onready var Stamina : TextureProgressBar = $HUD/Stamina
@onready var Hurtbox : Area2D = $Hurtbox
@onready var ItemHolding : CharacterBody2D = $ItemHolding
@onready var Footsteps : AudioStreamPlayer2D = $Footsteps
@onready var Reach : Area2D = $Reach
@onready var DmgEffectPlayer : AnimationPlayer = $HUD/DMGEffect/AnimationPlayer
@onready var DmgEffect : ColorRect = $HUD/DMGEffect

# WATER CHECK

func in_water_once() -> void:
	in_water = not Hurtbox.overlaps_area(root.get_node("Islands/Island"))
	
	if in_water:
		Sprite.texture = water_texture
	else:
		Sprite.texture = land_texture
		Stamina.hide()
		
	return

func _ready() -> void:
	position += screen_size / 2
	call_deferred("in_water_once")
	global.modify_inventory.connect(ItemHolding.update_texture)
	DmgEffect.modulate = Color.TRANSPARENT
	return

func _process(delta) -> void:
	
	var direction : Vector2 = Input.get_vector("move_left_0", "move_right_0", "move_up_0", "move_down_0")
	
	velocity += direction
	velocity = velocity.lerp(Vector2(0, 0), delta * 8 * (int(in_water) * 1.1 + 1))
	position += velocity * delta / 0.02
	
	ItemHolding.position.x = sign(velocity.x + 0.0000000001) * 15
	ItemHolding.rotation = ItemHolding.old_rot * sign(velocity.x + 0.0000000001)
	
	
	# Water logic
	if !in_water:
		dps = 0
	else:
		breath_left -= delta
		Stamina.value = breath_left * 10
		if breath_left <= 0:
			dps = 10

	# Audio
	
	# Footstep sounds
	if not direction:
		footsteps_playing = false
		Footsteps.stop()
	elif not footsteps_playing:
		footsteps_playing = true
		change_footstep_sound()
		Footsteps.play()
		
	return

#
# DAMAGE PROCESSING
#

func _on_Hurtbox_area_entered(area) -> void:
	if area.name.contains("Island"):
		Stamina.hide()
		Sprite.texture = land_texture
		in_water = false
	return

func _on_Hurtbox_area_exited(area) -> void:
	if area.name.contains("Island"):
		Stamina.show()
		Stamina.value = 100
		Sprite.texture = water_texture
		breath_left = 10
		in_water = true
	return

func _on_dps_timeout() -> void:
	call_deferred("damage", dps / 2.0, true)
	return

# DEBUG
func _input(event) -> void: # DEBUG
	if event.is_action_pressed("hotbar_4"):
		_on_Hurtbox_area_entered(root.get_node("Islands/Island"))
	return

# REACH
func reload_reach() -> void:
	Reach.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property($Reach, "scale", Vector2.ONE, 2.0)
	return

# FOOTSTEPS

func _on_footsteps_finished() -> void:
	footsteps_playing = true
	Footsteps.pitch_scale = randf_range(0.6, 1.1)
	await get_tree().create_timer(0.3).timeout
	change_footstep_sound()
	Footsteps.play()
	return

func change_footstep_sound() -> void:
	if in_water:
		Footsteps.stream = walk_sfx.water
	else:
		Footsteps.stream = walk_sfx.grass
	return


func damage(amount, show_effect) -> void:
	if amount == 0: 
		return
	
	if show_effect:
		DmgEffectPlayer.play("damage")
	return

func a(hi):
	print(hi)
