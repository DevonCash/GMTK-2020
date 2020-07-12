extends Area2D


enum State {stopped, MIN, rolling, MAX, hit}
var state = State.MIN
var timer
var player_ref
var camera_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("MinTimer")
	timer.start( 2 )
	timer.connect("timeout", self, "_on_MinTimer_timeout")
	camera_ref = owner
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_ref.repo("Bomb", global_position)
	#pass


func _on_MinTimer_timeout():
	if(state < 3):
		state = min((state + 1), 3)
		#print(state)
		$AnimatedSprite.speed_scale = $AnimatedSprite.speed_scale + (state * 0.3)
		timer.start(3)
