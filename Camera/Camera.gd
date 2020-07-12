extends Node2D


enum State {rolling, hacking}
var state = State.rolling
var speed = 1.0
const MAX_ZOOM = 1.1
const MIN_ZOOM = 0.7
var ZOOM_RANGE
const LOW_DIST_THRESH = 110.0
const HIGH_DIST_THRESH = 510.0
var DIST_RANGE
onready var EasyTrack = preload("res://Obstacles/Easy_Track.tscn")
var bomb_pos = Vector2.ZERO
var player_pos = Vector2.ZERO
var dist = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	ZOOM_RANGE = MAX_ZOOM - MIN_ZOOM
	DIST_RANGE = HIGH_DIST_THRESH - LOW_DIST_THRESH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= 1.0 * speed
	update_distance()
	match state:
		State.rolling:
			update_zoom()

func update_zoom():
	if(player_pos.distance_to(get_global_mouse_position()) > 10):
		var perc = (dist - LOW_DIST_THRESH) / DIST_RANGE
		var zscale = (perc * ZOOM_RANGE) + MIN_ZOOM
		$Camera2D.zoom = Vector2(zscale, zscale)

func update_distance():
	dist = bomb_pos.distance_to(player_pos)

func repo(obj, pos):
	match obj:
		"Bomb":
			bomb_pos = pos
		"Player":
			player_pos = pos

func _on_ScreenEdge_area_exited(area):
	if(area.get_name() == "TrackEndTile"):
		var track = EasyTrack.instance()
		track.position = $TrackSpawner/SpawnPoint.global_position
		get_parent().call_deferred("add_child", track)


func _on_TrackRemover_area_exited(area):
	
	#print(area.get_name())
	if(area.get_name() == "TrackEndTile"):
		area.owner.call_deferred("queue_free")
