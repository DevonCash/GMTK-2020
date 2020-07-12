extends KinematicBody2D

onready var up = "res://textures/Guard/guard_typeA_head_N.png"
onready var side = "res://textures/Guard/guard_typeA_head_W.png"
onready var down = "res://textures/Guard/guard_typeA_head_S.png"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_sprite(dir, flip = false):
	match dir:
		"up":
			$Head.texture = up
		"down":
			$Head.texture = down
		"side":
			$Head.texture = side
			$Head.flip_h = flip
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
