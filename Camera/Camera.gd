extends Node2D


enum State {rolling, hacking}
var state = State.rolling
var speed = 1.0
const MAX_ZOOM = 1.1
const MIN_ZOOM = 0.7
onready var EasyTrack = preload("res://Obstacles/Easy_Track.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= 1.0 * speed

func _on_ScreenEdge_area_exited(area):
	if(area.get_name() == "TrackEndTile"):
		var track = EasyTrack.instance()
		track.position = $TrackSpawner/SpawnPoint.global_position
		get_parent().call_deferred("add_child", track)


func _on_TrackRemover_area_exited(area):
	
	#print(area.get_name())
	if(area.get_name() == "TrackEndTile"):
		area.owner.call_deferred("queue_free")
