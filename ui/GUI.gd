extends CanvasLayer

var elapsed_time: float = 0
var outer_done: bool = false
var anim_done: bool = false
var characters: int = 0
var paused: bool = false
var settings_screen: int = 0
var settings_id = 5

func typewriter(delta):
	if not (anim_done or paused):
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
func pause(event):
	if event.is_action_pressed("ui_pause"):
		paused = !paused
		if paused:
			get_tree().set_deferred("paused", true)
			$Control/Pause.show()
			$Control/Pause/AnimationPlayer.play("pause")
		else:
			get_tree().paused = false
			$Control/Pause/AnimationPlayer.play_backwards("pause")

func _on_AnimationPlayer_animation_finished(anim_name):
	if not paused:
		$Control/Pause.hide()

func _ready():
	$Control/Pause.hide()
	$Control/Place/Outer.visible_characters = 0
	$Control/Place/Inner.visible_characters = 0

func _process(delta):
	typewriter(delta)
	if not paused: $Control/FPS.text = "fps: " + str(Engine.get_frames_per_second())

func _input(event):
	pause(event)
