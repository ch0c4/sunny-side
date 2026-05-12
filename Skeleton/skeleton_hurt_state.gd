class_name SkeletonHurtState extends State

@export var animation_player: AnimationPlayer

@onready var skeleton: Skeleton = get_owner()


func enter() -> void:
	animation_player.play("hurt")
	animation_player.animation_finished.connect(_on_hurt_finished)
	skeleton.hurtbox.is_invincible = true

	if skeleton.last_hitbox:
		CharacterMover.apply_knockback(skeleton, skeleton.last_hitbox.knockback)


func exit() -> void:
	animation_player.animation_finished.disconnect(_on_hurt_finished)
	skeleton.hurtbox.is_invincible = false


func physics_update(delta: float) -> void:
	CharacterMover.decelerate(skeleton, skeleton.movement_stats, delta)
	CharacterMover.move(skeleton)


func _on_hurt_finished(_anim_name: StringName) -> void:
	if MainInstance.player:
		transitionned.emit(self, "Chase")
	else:
		transitionned.emit(self, "Idle")
