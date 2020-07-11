extends KinematicBody2D

export var speed = 10;
export var force = 10;
export var damage = 10;

var direction: Vector2 = Vector2(0, -1);
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot(dir):
	direction = dir;
	self.look_at(position + direction);
	
func _physics_process(delta):
	var collided = move_and_collide(delta * direction * speed);
	
	if not collided: return;
	if collided.collider.has_method('onHacked'): 
		collided.collider.onHacked(self,damage,0);
	queue_free();
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
