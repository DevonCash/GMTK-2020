extends KinematicBody2D

var dir = Vector2.ZERO
var power = 1
var reflections = 0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	print("bullet is alive")
	dir = Vector2(600, 0).rotated(rotation)
	$Timer.start(2)

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var collision = move_and_collide(dir * delta)
	if collision:
		print(collision.collider.name)
		if collision.collider.has_method("hit"):
			collision.collider.hit(power, collision.normal)
		if(reflections <= 3):
			reflections += 1
			dir = dir.bounce(collision.normal)
		else:
			queue_free()
		
#
#func _on_Area2D_area_entered(area):
#	if(reflections == 0):
#		print("bounce")
#		var normal = get_collision_normal()
#		rotation += -45 if rng.randi_range(0, 1) == 0 else 45
#
#		dir = Vector2(600, 0).rotated(rotation)
#		reflections += 1
#	else:
#		queue_free()
#	if(area.has_method("damage")):
#		area.damage(power)
	#queue_free()


func _on_Timer_timeout():
	queue_free()
