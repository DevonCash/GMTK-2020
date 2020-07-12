extends KinematicBody2D

export var speed=100
export var maxspeed = 100
var target
var target_position
var rng = RandomNumberGenerator.new()
enum State {finding, approaching, attacking, arriving, reloading}
var state = State.arriving
var fired_rounds = 0
var MAX_ROUNDS = 4
var can_fire = true
var firing_range = 200
var distance_from_target
onready var bullet = preload("res://Obstacles/Guard/Bullet.tscn") 
# Called when the node enters the scene tree for the first time.
func _ready():
	#print("ready")
	state = State.arriving
	$ArrivalTimer.start(2)
	pass # Replace with function body.

func _physics_process(delta):
	match state:
		State.arriving:
			move_right(delta)
		State.finding:
			#acquire target
			acquire_target()
		State.approaching:
			#tilt to face target
			update_distance()
			if(distance_from_target > firing_range):
				move_at_target(delta)
			else:
				state = State.attacking
		State.attacking:
			update_distance()
			fire()
			pass
			
func fire():
	if(can_fire and fired_rounds < MAX_ROUNDS):
		#print("fireing")
		can_fire = false
		fired_rounds += 1
		#instantiate bullet
		var b = bullet.instance()
		b.global_position = $GuardArms/Sprite/barrel.global_position
		#b.dir = target_position
		b.look_at(target_position)
		owner.call_deferred("add_child", b)
		$GunCooldown.start(0.2)
	elif fired_rounds >= MAX_ROUNDS:
		#print("reloading..")
		$ReloadTimer.start(1)
		state = State.finding

func update_distance():
	target_position = target.global_position
	distance_from_target = global_position.distance_to(target_position)
	update_angle()
	#print(distance_from_target)
	
func update_angle():
	#var dir = (target_position - global_position).normalized();
	var theta = Vector2.DOWN.angle_to(global_position - target_position)
	$GuardArms/Sprite.flip_h = theta > 0
	$GuardArms.look_at(target.position)
	
func move_right(delta):
	position.x += speed * delta
	
	
func move_at_target(delta):
	#print("moving towards", target)
	var direction = target_position - global_position
	direction = direction.normalized()
	global_position +=  direction * speed * delta
	
#	var dir = (target_position - global_position).normalized();
#	var theta = Vector2.DOWN.angle_to(global_position - target_position)
#
#	var velocity =  dir * clamp(speed * delta * 100, -maxspeed, maxspeed)
#	move_and_slide( velocity, Vector2.ZERO, false, 3, 0, false);
	
func acquire_target():
	rng.randomize()
	var c = rng.randi_range(0, 1)
	#target = get_node("/root").get_node("Node2D").find_node(("Player" if c == 0 else "Bomb"))
	target = get_node("/root").get_node("Node2D").find_node(("Player"))
	#print("target acquired! ", target)
	state = State.approaching
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ArrivalTimer_timeout():
	if(state == State.arriving):
		state = State.finding


func _on_GunCooldown_timeout():
	can_fire = true


func _on_ReloadTimer_timeout():
	fired_rounds = 0
