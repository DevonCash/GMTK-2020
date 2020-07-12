extends Node2D


# Declare member variables here. Examples:
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	match rng.randi_range(0,3):
		0:
			$death1.play()
		1:
			$death2.play()
		2:
			$death3.play()
		3:
			$death4.play()
	$Head.apply_impulse(Vector2.UP * 1000, Vector2.LEFT * 1000)
	$Body.apply_impulse(Vector2.LEFT * 1000, Vector2.UP * 1000)
	$Body.apply_impulse(Vector2.RIGHT * 1000, Vector2.UP * 1000)
	$Cleanup.start(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Cleanup_timeout():
	queue_free()
