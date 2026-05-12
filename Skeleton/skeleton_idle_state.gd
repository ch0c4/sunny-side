class_name SkeletonIdleState extends State

@export var animation_player: AnimationPlayer

@onready var skeleton: Skeleton = get_owner()


func enter() -> void:
	animation_player.play("idle")


func physics_update(delta: float) -> void:
	CharacterMover.decelerate(skeleton, skeleton.movement_stats, delta)
	CharacterMover.move(skeleton)

	var player := MainInstance.player
	if player and skeleton.global_position.distance_to(player.global_position) <= skeleton.aggro_range:
		transitionned.emit(self, "Chase")
