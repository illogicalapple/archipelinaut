extends CanvasLayer

var elapsed_time: float = 0
var outer_done: bool = false
var anim_done: bool = false
var characters: int = 0

func typewriter(delta):
	if not anim_done:
		elapsed_time += delta
		if($Control/Place/Outer.get_visible_characters() >= $Control/Place/Outer.text.length()):
			if not outer_done:
				outer_done = true
				elapsed_time = -0.3
				characters = 0
			if elapsed_time > 0:
				$Control/Place/Inner.visible_characters = elapsed_time / 0.06
				if(characters < $Control/Place/Inner.get_visible_characters()):
					$Control/Place/SFX.play()
					characters = $Control/Place/Inner.get_visible_characters()
					if($Control/Place/Inner.get_visible_characters() >= $Control/Place/Inner.text.length()):
						anim_done = true
						$Control/Place/AnimationPlayer.play("fade_out")
		else:
			$Control/Place/Outer.visible_characters = elapsed_time / 0.06
			if(characters < $Control/Place/Outer.get_visible_characters()):
				$Control/Place/SFX.play()
				characters = $Control/Place/Outer.get_visible_characters()

func _ready():
	$Control/Place/Outer.visible_characters = 0
	$Control/Place/Inner.visible_characters = 0

func _process(delta):
	typewriter(delta)
