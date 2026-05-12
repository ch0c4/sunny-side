class_name SkeletonAttackState extends State

@export var animation_player: AnimationPlayer
@export var weapon_hitbox: Hitbox

@onready var skeleton: Skeleton = get_owner()


func enter() -> void:
	animation_player.play("attack")
	animation_player.animation_finished.connect(_on_attack_finished)

	var player := MainInstance.player
	if player:
		weapon_hitbox.knockback = skeleton.global_position.direction_to(player.global_position) * skeleton.knockback_amount


func exit() -> void:
	animation_player.animation_finished.disconnect(_on_attack_finished)
	weapon_hitbox.clear_stores_target()


func physics_update(delta: float) -> void:
	CharacterMover.decelerate(skeleton, skeleton.movement_stats, delta)
	CharacterMover.move(skeleton)


func _on_attack_finished(_anim_name: StringName) -> void:
	if MainInstance.player:
		transitionned.emit(self, "Chase")
	else:
		transitionned.emit(self, "Idle")
