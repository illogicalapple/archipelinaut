extends RigidBody2D

var thingy = true
var direction = PI
var velocity = 0
var things = PI / 2

var pirate = preload("peerate.tscn")

func spawn(amount):
	for i in range(amount):
		var instance = pirate.instantiate()
		var heehaw = randf_range(-PI, PI)
		instance.position = position + (Vector2(sin(heehaw), cos(heehaw)) * randf_range(100, 150))
		get_parent().add_child(instance)

func _process(delta):
	$Post.global_rotation = 0
	$Post.position = Vector2(0, -35)
	if thingy:
		$Bote.rotation = linear_velocity.angle() + PI / 2
		linear_velocity = Vector2(cos(direction), sin(direction)) * 60
		velocity += randf_range(-0.5, 0.5) + sin(things) / 16
		velocity = clamp(velocity, -1, 1)
		direction += velocity * delta
	$Flag/Flag.skew = -$Bote.rotation - PI / 2
	$Flag.global_rotation = PI - $Flag/Flag.skew
	$CollisionShape2D.rotation = $Bote.rotation
	if fmod($Flag.rotation, PI * 2) > PI:
		$Flag.z_index = -1
	else:
		$Flag.z_index = 0
	things += delta * 2

func _physics_process(delta):
	angular_velocity = 0
#	if not rotation == 0:
#		$Bote.rotation = rotation
#		$CollisionShape2D.rotation = rotation
#		rotation = 0

func _on_body_entered(body):
	if body.name == "BoatCollisions":
		linear_velocity = Vector2.ZERO
		thingy = false
		spawn(10)
		sleeping = true
