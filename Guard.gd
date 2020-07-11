extends KinematicBody2D

const BulletPrototype = preload('res://Bullet.tscn');

export var speed = 200;
export var min_range = 250;
export var max_range = 500;
export var transition_delay = 0.0;
export var firing_delay = 0;

onready var Player = get_node('/root/Node2D/PlayerBody');

enum State {STATE_MOVE = 0, STATE_FIRE}

var state = State.STATE_FIRE
func _ready():
	print($RayCast2D);

func FireGun(dir):
	if not $Reload.is_stopped(): return;
	var bullet = BulletPrototype.instance();
	bullet.position = position + dir * 20
	bullet.shoot(dir);
	get_parent().add_child(bullet);
	$Reload.start(firing_delay);
	
func set_state(new_state):
	if(state == new_state): return;
	state = new_state;
	$TransitionState.start(transition_delay)

func _physics_process(delta):
	if !$TransitionState.is_stopped():return;
	$RayCast2D.cast_to = Player.position - position
	var hit = $RayCast2D.get_collider();
	if hit == Player and position.distance_to(hit.position) <= engagement_range:
		set_state(State.STATE_FIRE)
	else: set_state(State.STATE_MOVE)
	var dir = (Player.position - position).normalized();
	
	if state == State.STATE_MOVE:
		move_and_slide(dir * speed );
	elif state == State.STATE_FIRE:
		FireGun(dir);
	# Check to see if we can see the player
	# If state is move, move towards center
