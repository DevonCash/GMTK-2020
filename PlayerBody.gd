extends KinematicBody2D

export var speed=2000
export var maxspeed = 400

export (int, 0, 200) var push = 25
export var hackcooldownmax = .3
export var doubleslashwindow = .1

export var lunge_duration = .1;
export var hack_cooldown = .5;
export var kick_cooldown = .1;
export var dash_cooldown = .3;

export var dash_mult = 2;
export var hack_mult = 5;
var lunge_mult = 4

# export var lunging = false;
export var kickforce = 1800

var hackcooldown = 0
var doubleslashdelay = 0
var isHacking=false
var stunned

var lunge_dir;

var kickcooldown
var isKicking

var velocity = Vector2()
var afterimage = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	afterimage = load("res://Player/DashEffect.tscn")
	doHack()

func getInput():
	var axis = Vector2()
	axis.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

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
#	print(velocity)

func _physics_process(delta):
	var dir = (get_global_mouse_position() - position).normalized();
	var dist = position.distance_to(get_global_mouse_position())
	var theta = Vector2.DOWN.angle_to(position - get_global_mouse_position())
	
	if abs(theta) < PI/2: 
		$AnimatedSprite.play( 'run_up' if dist > 75 else 'idle_up');
	else:
		$AnimatedSprite.play( 'run_side' if dist > 75 else'idle_side');
	$AnimatedSprite.flip_h = theta < 0;

	var lunging = not $LungeTimer.is_stopped()
	var lockout = not $LockoutTimer.is_stopped()

	dir =  lunge_dir if lunging else dir;
	var velocity =  dir * clamp(speed * delta * 1000, -maxspeed, maxspeed)
	if lunging:
		print("l")
		velocity *= lunge_mult
		var obj = afterimage.instance()
		obj.position = position
		obj.flip(theta < 0)
		var parent_node = get_parent()
		parent_node.call_deferred("add_child", obj)  
		
	elif lockout: velocity = Vector2.ZERO

	move_and_slide( velocity, Vector2.ZERO, false, 3, 0, false);

func _process(delta):
	update()

	if $LockoutTimer.is_stopped():
		if Input.is_action_pressed("hack"):
				doHack()
		if Input.is_action_pressed("kick"):
				doKick()
	# if doubleslashdelay:
	# 	doubleslashdelay = clamp(doubleslashdelay-delta,0,doubleslashdelay)

func _draw():
	draw_line(Vector2(),get_local_mouse_position(),Color(1,1,1,1),3)

func _unhandled_input(event):
	if event.is_action_pressed('ui_up'): dash(Vector2.UP);
	if event.is_action_pressed('ui_down'): dash(Vector2.DOWN);
	if event.is_action_pressed('ui_left'): dash(Vector2.LEFT);
	if event.is_action_pressed('ui_right'): dash(Vector2.RIGHT);

func doKick():
	var vector =  rad2deg(get_angle_to(get_global_mouse_position()))+90
	var norm = get_angle_to(get_global_mouse_position())+2/PI
	norm = Vector2(cos(norm),sin(norm))
	var kick = $Kick
	kick.rotation_degrees = vector
	kick.visible = true
	kick.get_node("AnimationPlayer").play("Kick")
	isKicking=true
	yield(kick.get_node("AnimationPlayer"),"animation_finished")
	isKicking=false
	kick.visible = false

func lunge(dir, magnitude):
	$LungeTimer.start(lunge_duration);
	lunge_dir = dir;

func dash(dir):
	if not $LockoutTimer.is_stopped(): return;
	lunge(dir, dash_mult);
	$LockoutTimer.start(dash_cooldown);

func doHack():
	if not $LockoutTimer.is_stopped(): return;

	#Basic Slash
	var vector =  (get_global_mouse_position() - position ).normalized()
	lunge(vector, hack_mult)

	var weapon = $Blade #Glorious nippon steel, your father's blade...
	# weapon.rotation_degrees = Vector2.UP.angle_to(vector);
	$Blade.look_at(get_global_mouse_position());
	$Blade.rotation += PI/2;
	$Blade.visible = true
	$Blade/AnimationPlayer.play("Slash")

	$LockoutTimer.start(hack_cooldown);

	yield(weapon.get_node("AnimationPlayer"),"animation_finished")
	
	weapon.visible = false

func _on_Blade_body_entered(area):
	if area.has_method("onHacked"):
		area.onHacked(self,1,0)

func _on_Kick_body_entered(area):
	if area.has_method("onHacked") && !(area == self):
		print("KickedOther")
		area.onHacked(self,0,kickforce+velocity.length())

func onHacked(who,damage,knockback=0):
	
	if who == self:
		return
	print("PlayerDamaged")
	if knockback:
		var vector = who.position
		self.velocity -= vector.normalized()*knockback
	
	#Play damaged/flashing animation here
	stunned = true
	$AnimationPlayer.play("PlayerDamaged")
	yield(get_tree().create_timer(5),"timeout")
	stunned = false


func _on_Kick_area_entered(area):
	pass # Replace with function body.
