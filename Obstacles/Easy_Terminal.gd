extends Node2D


#export var obstacle = "Terminal"
#onready var obj = preload("res://" + obstacle + "/" + obstacle + ".tscn")
onready var obj = preload("res://Obstacles/Terminal/Terminal.tscn")
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	
func initialize():
	rng.randomize()
	#flip coin
	var c = rng.randi_range(0,1)
	print(c)
	#spawn terminal in left or right
	var pos = $EasySpawnerLeft.position if c == 0 else $EasySpawnerRight.position
	var obs_instance = obj.instance()
	obs_instance.position = pos
	obs_instance.set_global_scale(Vector2((-1 if c == 0 else 1),1))
	add_child(obs_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
