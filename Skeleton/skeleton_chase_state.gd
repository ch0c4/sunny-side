class_name SkeletonChaseState extends State

@export var animation_player: AnimationPlayer

@onready var skeleton: Skeleton = get_owner()


func enter() -> void:
	animation_player.play("walk")


func physics_update(delta: float) -> void:
	var player := MainInstance.player
	if not player:
		transitionned.emit(self, "Patrol")
		return

	var distance := skeleton.global_position.distance_to(player.global_position)

	if distance <= skeleton.attack_range:
		transitionned.emit(self, "Attack")
		return

	if distance > skeleton.aggro_range:
		transitionned.emit(self, "Patrol")
		return

	skeleton.navigation_agent.target_position = player.global_position

	if skeleton.navigation_agent.is_navigation_finished():
		return

	var next_pos := skeleton.navigation_agent.get_next_path_position()
	var direction := skeleton.global_position.direction_to(next_pos)
	CharacterMover.accelerate_in_direction(skeleton, direction, skeleton.movement_stats, delta)
	CharacterMover.move(skeleton)
