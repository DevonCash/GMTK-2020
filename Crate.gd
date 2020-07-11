extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func onHacked(who,damage,knockback):
	print("hacked")
	if damage:
		self.queue_free()
	if knockback:
		print("Kicked!")
		var vector = (self.position-who.position).normalized()
		self.apply_central_impulse(vector*knockback)
