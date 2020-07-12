extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health = 4
enum State {ready, hacking, destroyed, hit}
var state = State.ready
var origin = position
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.set_animation("default")
	state = State.ready
	origin = position

func _process(delta):
	match state:
		State.hit:
			$AnimatedSprite.set_offset(Vector2(rng.randi_range(-3,3),rng.randi_range(-3,3)))
			state = State.hacking
		State.hacking:
			$AnimatedSprite.set_offset(Vector2(0,0))

func onHacked(who, damage, knockback):
	#queue up hacking prompt
	print("hacked")
	if damage:
		health -= damage;
		state = State.hit
		if state == State.ready:
			$AnimatedSprite.set_animation("hacked")
		if health <= 0: self.queue_free()
		
		
