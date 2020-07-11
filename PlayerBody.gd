extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed=2000
export var maxspeed = 400

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	var axis = getInput()
	if axis.x == 0 && !isHacking:
		applySlowdownx(8000*delta)
	if axis.y == 0 && !isHacking:
		applySlowdowny(8000*delta)
	if velocity.length() > speed:
		if velocity.x > speed:
			applySlowdownx(400*delta)
		if velocity.y > speed:
			applySlowdowny(400*delta)
		print("Sword dash slowdown")
	if axis && !isHacking:
		applyMotion(axis*speed*delta)
	
	if !velocity: 
		return
#	print(velocity)
	move_and_slide(velocity,Vector2(),false,3,0,false)
	# after calling move_and_slide()
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		collision.collider.apply_central_impulse(-collision.normal * push)
		
export (int, 0, 200) var push = 25
export var hackcooldownmax = .3
export var doubleslashwindow = .1
export var lungespeed = 800
export var kickforce = 1800
var hackcooldown = 0
var doubleslashdelay = 0
var isHacking=false
var stunned

var kickcooldown
var isKicking

func _process(delta):
	update()
	if Input.is_action_pressed("hack"):
#		print("click!")
		if !hackcooldown && !isHacking:
			doHack()
		else:
			pass
#			print("Still cooling down! Wait ",hackcooldown," seconds!")
	if Input.is_action_pressed("kick"):
		if !kickcooldown && !isKicking:
			doKick()
	if hackcooldown:
		hackcooldown = clamp(hackcooldown - delta,0,hackcooldown)
	if doubleslashdelay:
		doubleslashdelay = clamp(doubleslashdelay-delta,0,doubleslashdelay)

func _draw():
	draw_line(Vector2(),get_local_mouse_position(),Color(1,1,1,1),3)

func doKick():
#	var vector =  self.position - get_global_mouse_position().normalized()
#	velocity=velocity+vector*10
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

func doHack():
	#Basic Slash
	var vector =  rad2deg(get_angle_to(get_global_mouse_position()))+90
	var norm = get_angle_to(get_global_mouse_position())
	norm = Vector2(cos(norm),sin(norm))
	velocity = velocity + norm*lungespeed
	var weapon = $Blade #Glorious nippon steel, your father's blade...
	weapon.rotation_degrees = vector
	weapon.visible = true
	weapon.get_node("AnimationPlayer").play("Slash")
	isHacking=true
	yield(weapon.get_node("AnimationPlayer"),"animation_finished")
	isHacking=false
	hackcooldown=hackcooldownmax
	weapon.visible = false

func _on_Blade_body_entered(node):
	if is_a_parent_of(node): return;
	if node.has_method("onHack"):
		node.onHack(self,1)

func _on_Kick_body_entered(area):
	if area.has_method("onKick") && !(area == self):
		print("KickedOther")
		area.onKick(self,kickforce+velocity.length())

func onHack(who,damage):
	if who == self:
		return
	#Play damaged/flashing animation here
	stunned = true
#	yield() #Yield until animation is over
	stunned = false
