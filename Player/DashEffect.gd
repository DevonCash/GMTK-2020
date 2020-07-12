extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _init():
	print("dashing!")

# Called when the node enters the scene tree for the first time.
func _process(delta):
	print($AnimatedSprite.frame)
	if($AnimatedSprite.frame == 4):
		queue_free()

func flip(b):
	$AnimatedSprite.flip_h = b

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pas
