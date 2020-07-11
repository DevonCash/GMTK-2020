extends RigidBody2D

signal hacked;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect('hacked', self, '_on_StaticBody2D_hacked');
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func onHacked(who, damage, knockback = null):
	print(damage, knockback);
