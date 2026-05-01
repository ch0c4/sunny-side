class_name ColletableSpawnState extends State

const GRAVITY := 40.0 

@export var timer: Timer

@onready var collectable: Node2D = get_owner()

var spawn_v_force : float = -200.0
var spawn_dir_force : float = 100.0
var spawn_dir := Vector2.ZERO
var spawn_dir_velocity := Vector2.ZERO
var damping := 20.0

func enter() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
	var rdm_angle = deg_to_rad(randf_range(0.0, 360.0))
	spawn_dir = Vector2(sin(rdm_angle), cos(rdm_angle))
	timer.start()


func exit() -> void:
	timer.timeout.disconnect(_on_timer_timeout)


func physics_update(delta: float) -> void:
	spawn_v_force += GRAVITY
	var spawn_v_velocity = Vector2(0.0, spawn_v_force)
	spawn_dir_velocity = spawn_dir * spawn_dir_force
	spawn_dir_velocity = spawn_dir_velocity.limit_length(spawn_dir_velocity.length() - damping)
	
	var velocity = spawn_v_velocity + spawn_dir_velocity
	collectable.position += velocity * delta


func _on_timer_timeout() -> void:
	transitionned.emit(self, "Collectable")
