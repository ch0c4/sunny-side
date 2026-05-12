class_name SkeletonDeathState extends State

@export var animation_player: AnimationPlayer
@export var floor_collision: CollisionShape2D

@onready var skeleton: Skeleton = get_owner()


func enter() -> void:
	animation_player.play("death")
	animation_player.animation_finished.connect(_on_death_finished)
	skeleton.hurtbox.is_invincible = true
	floor_collision.set_deferred("disabled", true)


func _on_death_finished(_anim_name: StringName) -> void:
	skeleton.queue_free()
