extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func onHack():
	self.queue_free()

func onKick(who,force):
	pass
	print("Kicked!")
	var vector = (self.position-who.position).normalized()
	self.apply_central_impulse(vector*force)
