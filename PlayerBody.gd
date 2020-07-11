extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed=2000
export var maxspeed = 400

var velocity = Vector2()
var acceleratingx = false
var acceleratingy = false

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
	move_and_slide(velocity)
	

export var hackcooldownmax = .3
export var doubleslashwindow = .1
export var lungespeed = 800
var hackcooldown = 0
var doubleslashdelay = 0
var isHacking=false

func _process(delta):
	update()
	if Input.is_action_pressed("hack"):
#		print("click!")
		if !hackcooldown && !isHacking:
			doHack()
		else:
			pass
#			print("Still cooling down! Wait ",hackcooldown," seconds!")
	if hackcooldown:
		hackcooldown = clamp(hackcooldown - delta,0,hackcooldown)
	if doubleslashdelay:
		doubleslashdelay = clamp(doubleslashdelay-delta,0,doubleslashdelay)

func _draw():
	draw_line(Vector2(),get_local_mouse_position(),Color(1,1,1,1),3)

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

func _on_Blade_area_entered(area):
	if area.has_method("onHack"):
		area.onHack(self,1)
