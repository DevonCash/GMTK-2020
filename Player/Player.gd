extends KinematicBody2D

export var speed=2000
export var maxspeed = 400
export var dash_mult = 3;
export var hack_mult = 5;
var lunge_mult = 4
var can_dash = true
var can_hack = true
var dashing_dir
# Declare member variables here. Examples:
var dir
var dist
var theta
var font
var camera_ref
export var verbose = false
enum State {idle, running, dashing, lunging, hacking, kicking, hurt}
var state
var velocity = Vector2.ZERO
onready var slash_side = preload("res://Player/hack_side.tscn") 
onready var afterimage = preload("res://Player/DashEffect.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://textures/Fonts/Ardeco.ttf")
	font.size = 20
	state = State.running
	camera_ref = owner.get_node("Camera")
	pass # Replace with function body.

func applySlowdownx(factor):
	if velocity.x > factor:
		velocity.x -= factor
	else:
		velocity.x =0
func applySlowdowny(factor):
	if velocity.y > factor:
		velocity.y -= factor
	else:
		velocity.y = 0

func applyMotion(accel):
	velocity.x = clamp(velocity.x + accel.x,-maxspeed,maxspeed)
	velocity.y = clamp(velocity.y + accel.y,-maxspeed,maxspeed)

func debugstatements():
	print("state ", get_state_name())
	print("animation ", $AnimatedSprite.animation)
	print("speed_scale ", $AnimatedSprite.speed_scale)
	print("frame ", $AnimatedSprite.frame)
	print("candash ", can_dash)
	print("can hack ", can_hack)
	print("dashdir ", dashing_dir)
	print("", $DashCooldown.is_stopped())

func _physics_process(delta):
	if(verbose):
		debugstatements()
	update_mouse_position(delta)
	update_blade(delta)
	match state:
		State.running:
			move_towards_mouse(delta)
		State.dashing:
			dash_move(delta)
		State.lunging:
			dash_move(delta)
			spawn_hit_box()
		State.hurt:
			print(get_state_name())
			move_towards_dir(delta)
		State.hacking:
			match $AnimatedSprite.frame:
				3:
					if(Input.is_action_just_pressed("hack")):
						#lung_attack
						dash_attack()
				4:
					if(Input.is_action_just_pressed("hack")):
						#lung_attack
						dash_attack()
				5:
					if(Input.is_action_just_pressed("hack")):
						#lung_attack
						dash_attack()
					else:
						print("done hacking")
						state = State.running
						$AnimatedSprite.speed_scale = 1
					#dash_attack()
	camera_ref.repo("Player", position)
	
func move_towards_dir(delta):
	translate(-dir)

func _process(delta):
	get_input()
	#update()
	
func get_state_name():
	match state:
		State.hacking:
			return "Hacking"
		State.running:
			return "Running"
		State.lunging:
			return "Lunging"
		State.dashing:
			return "Dashing"
		State.hurt:
			return "Hurt"
			

func get_input():
	if Input.is_action_just_pressed("ui_up") : dash(Vector2.UP)
	if Input.is_action_just_pressed("ui_down") : dash(Vector2.DOWN)
	if Input.is_action_just_pressed("ui_left"): dash(Vector2.LEFT)
	if Input.is_action_just_pressed("ui_right"): dash(Vector2.RIGHT)
	#if (Input.is_action_just_pressed("hack") and ((state != State.hacking) and state != State.lunging)): hack()
	if Input.is_action_just_pressed("hack"): hack()

func update_mouse_position(delta):
	dir = (get_global_mouse_position() - position).normalized();
	dist = position.distance_to(get_global_mouse_position())
	theta = Vector2.DOWN.angle_to(position - get_global_mouse_position())
	
func move_towards_mouse(delta):
	if abs(theta) < PI/2: 
		$AnimatedSprite.play( 'run_up' if dist > 75 else 'idle_up');
	else:
		$AnimatedSprite.play( 'run_down' if dist > 75 else'idle_down');
	$AnimatedSprite.flip_h = theta < 0;
	var velocity =  dir * clamp(speed * delta * 1000, -maxspeed, maxspeed)
	
	if(dist > 100.0):
		move_and_slide( velocity, Vector2.ZERO, false, 3, 0, false);


func dash_move(delta):
	var velocity =  dashing_dir * clamp(speed * delta * 1000, -maxspeed, maxspeed)
	velocity *= dash_mult
	var obj = afterimage.instance()
	obj.position = position
	obj.flip(theta < 0)
	var parent_node = get_parent()
	parent_node.call_deferred("add_child", obj)
	move_and_slide( velocity, Vector2.ZERO, false, 3, 0, false);
	
func dash(dir, magnitude = 0.0):
	if(can_dash):
		print("dashing")
		dashing_dir = dir
		state = State.dashing
		can_dash = false
		$DashCooldown.start(0.5 + magnitude)
		$DashDuration.start(0.1 + magnitude)
		
func dash_attack():
	print("DASH_ATTACK")
	var vector =  (get_global_mouse_position() - position ).normalized()
	dash(vector, 0.1)
	$AnimatedSprite.play("lunge")
	$AnimatedSprite.frame = 0
	state = State.lunging
		
func hack():
	if(can_hack and state != State.hacking):
		print("hacking")
		state = State.hacking
		can_hack = false
		$AnimatedSprite.play("attack_down")
		$AnimatedSprite.frame = 0
		$AnimatedSprite.speed_scale = 1.5
		#instantiate slash based on direction
		spawn_hit_box()
		#set hack cooldown
		$HackCooldown.start(1)
		
func spawn_hit_box():
	var s = slash_side.instance()
	s.position = $Blade.position
	s.rotation = get_node("Blade/Sprite").rotation
	get_node("Blade/Sprite").call_deferred("add_child", s)

func update_blade(delta):
	$Blade.look_at(get_global_mouse_position())
	
func hit(damage, normal):
	print("HIT BY BULLET")
	state = State.hurt
	dir = normal.bounce(normal)
	

func _on_DashCooldown_timeout():
	can_dash = true


func _on_DashDuration_timeout():
	if(state == State.dashing or state == State.lunging):
		state = State.running
		dashing_dir = null
		$AnimatedSprite.speed_scale = 1


func _on_HackCooldown_timeout():
	can_hack = true
