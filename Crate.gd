extends RigidBody2D
var health = 1

const variants = [
	{
		'sprite': 2,
		'extents': Vector2(22, 22),
		'health': 3
	},{
		'sprite': 1,
		'extents': Vector2(22, 16),
		'health': 2
	},{
		'sprite': 0,
		'extents': Vector2(16, 16),
		'health': 1
	}
]

var rng = RandomNumberGenerator.new();
func _ready():
	rng.randomize();
	var form = variants[rng.randi_range(0, 2)]; # Randomly select a variant crate

	#Set variable values
	$Sprite.frame = form.sprite;
	$CollisionShape2D.shape.extents = form.extents;
	health = form.health

func onHack(who,damage, force):
	health -= damage;
	#Decrement health and suffer effects. In this case, just so I know it's working!
	$Tween.interpolate_property(self,"modulate",Color(1,1,1),Color(3,3,3,3),.1,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"modulate",Color(3,3,3),Color(1,1,1,1),.1,Tween.TRANS_CUBIC,Tween.EASE_IN,.1)
	$Tween.start()

	yield($Tween, 'tween_completed')
	if health <= 0: queue_free()

func onKick(who,force):
	pass
	print("Kicked!")
	var vector = (self.position-who.position).normalized()
	self.apply_central_impulse(vector*force)
