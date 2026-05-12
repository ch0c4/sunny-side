class_name SkeletonPatrolState extends State

@export var animation_player: AnimationPlayer

@onready var skeleton: Skeleton = get_owner()

var _current_point_index: int = 0
var _wait_timer: float = 0.0
var _is_waiting: bool = false


func enter() -> void:
	if skeleton.patrol_points.is_empty():
		transitionned.emit(self, "Idle")
		return
	_is_waiting = false
	_move_to_current_point()
	animation_player.play("walk")


func physics_update(delta: float) -> void:
	var player := MainInstance.player
	if player and skeleton.global_position.distance_to(player.global_position) <= skeleton.aggro_range:
		transitionned.emit(self, "Chase")
		return

	if _is_waiting:
		_wait_timer -= delta
		if _wait_timer <= 0.0:
			_is_waiting = false
			_advance_to_next_point()
			animation_player.play("walk")
		CharacterMover.decelerate(skeleton, skeleton.movement_stats, delta)
		CharacterMover.move(skeleton)
		return

	var target := skeleton.patrol_points[_current_point_index]
	var dist := skeleton.global_position.distance_to(target.global_position)

	if dist < 8.0 or skeleton.navigation_agent.is_navigation_finished():
		_is_waiting = true
		_wait_timer = skeleton.patrol_wait_time
		animation_player.play("idle")
		return

	var next_pos := skeleton.navigation_agent.get_next_path_position()
	var direction := skeleton.global_position.direction_to(next_pos)
	CharacterMover.accelerate_in_direction(skeleton, direction, skeleton.movement_stats, delta)
	CharacterMover.move(skeleton)


func _move_to_current_point() -> void:
	skeleton.navigation_agent.target_position = skeleton.patrol_points[_current_point_index].global_position


func _advance_to_next_point() -> void:
	_current_point_index = (_current_point_index + 1) % skeleton.patrol_points.size()
	_move_to_current_point()
