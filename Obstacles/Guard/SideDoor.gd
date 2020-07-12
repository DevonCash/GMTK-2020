extends StaticBody2D

onready var guard = preload("res://Obstacles/Guard/Guard.tscn")
enum State {waiting, opening, spawning, closing, closed}
var state = State.waiting 
var num = 0
var max_num = 0
var rng = RandomNumberGenerator.new()
var can_spawn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	max_num = rng.randi_range(1, 3)
	$AnimatedSprite.stop()
	$OpenTimer.start(4)

func _process(delta):
	match state:
		State.opening:
			if($AnimatedSprite.frame == 3):
				$AnimatedSprite.speed_scale=0
				spawn()
		State.closing:
			if($AnimatedSprite.frame == 2):
				state = State.closed
func spawn():
	state = State.spawning
	if(num >= max_num):
		state = State.closing
		$AnimatedSprite.play("close")
		$AnimatedSprite.speed_scale = 1
	else:
		var man = guard.instance()
		man.global_position = global_position
		get_tree().get_root().get_node("Node2D").call_deferred("add_child", man)
		num += 1
		$SpawnTimer.start(0.4)
	
func open():
	state = State.opening
	$AnimatedSprite.play("default")
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OpenTimer_timeout():
	open()


func _on_SpawnTimer_timeout():
	spawn()
