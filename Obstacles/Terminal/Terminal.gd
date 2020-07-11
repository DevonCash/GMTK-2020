extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 4
enum State {ready, hacking, destroyed}
var state = State.ready

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_animation("default")
	state = State.ready

func onHacked(who, damage, knockback):
	#queue up hacking prompt
	print("hacked")
	if damage:
		health -= damage;
		if state == State.ready:
			state = State.hacking
			$AnimatedSprite.set_animation("hacking")
		if health <= 0: self.queue_free()
		
		
