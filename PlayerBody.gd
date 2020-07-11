extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var maxspeed = 300
export var accel = 800
export var turnaroundboost = 300
export var friction = 1500

var velocity = Vector2()
var acceleratingx = false
var acceleratingy = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		if velocity.y > 0:
			if Input.is_action_just_pressed("ui_up"):
				velocity.y -= turnaroundboost
		velocity += Vector2(0,-accel*delta)
		acceleratingy = true
	if Input.is_action_pressed("ui_right"):
		if velocity.x < 0:
			if Input.is_action_just_pressed("ui_right"):
				velocity.x += turnaroundboost
		velocity += Vector2(accel*delta,0)
		acceleratingx = true
	if Input.is_action_pressed("ui_left"):
		if velocity.x > 0:
			if Input.is_action_just_pressed("ui_left"):
				velocity.x -= turnaroundboost
		velocity += Vector2(-accel*delta,0)
		acceleratingx = true
	if Input.is_action_pressed("ui_down"):
		if velocity.y < 0:
			if Input.is_action_just_pressed("ui_down"):
				velocity.y += turnaroundboost
		velocity += Vector2(0,accel*delta)
		acceleratingy = true
	if !acceleratingx:
		if velocity.x > 0:
			velocity.x = clamp(velocity.x-friction*delta,0,maxspeed)
		else:
			velocity.x = clamp(velocity.x+friction*delta,-maxspeed,0)
	if !acceleratingy:
		if velocity.y > 0:
			velocity.y = clamp(velocity.y-friction*delta,0,maxspeed)
		else:
			velocity.y = clamp(velocity.y+friction*delta,-maxspeed,0)
	
	
	velocity.x = clamp(velocity.x,-maxspeed,maxspeed)
	velocity.y = clamp(velocity.y,-maxspeed,maxspeed)
	move_and_collide(velocity*delta)
	acceleratingx = false
	acceleratingy = false
	

export var hackcooldownmax = .1
var hackcooldown = 0

func _process(delta):
	if Input.is_action_pressed("hack"):
		if !hackcooldown:
			doHack()
		else:
			print("Still cooling down! Wait ",hackcooldown," seconds!")
	if hackcooldown:
		hackcooldown = clamp(hackcooldown - delta,0,hackcooldown)

func doHack():
	var vector =  rad2deg(get_angle_to(get_global_mouse_position()))+90
	var weapon = $Blade #Glorious nippon steel, your father's blade...
	weapon.rotation_degrees = vector
	weapon.visible = true
	weapon.get_node("AnimationPlayer").play("Slash")
	yield(weapon.get_node("AnimationPlayer"),"animation_finished")
	weapon.visible = false
	hackcooldown = hackcooldownmax


func _on_Blade_area_entered(area):
	if area.has_method("onHack"):
		area.onHack(self,1)
