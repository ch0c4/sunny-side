class_name SkeletonFlipComponent extends Node2D

@onready var skeleton: Skeleton = get_owner()


func _physics_process(_delta: float) -> void:
	if skeleton.velocity.x > 0.0:
		skeleton.scale.x = skeleton.scale.y * 1
	if skeleton.velocity.x < 0.0:
		skeleton.scale.x = skeleton.scale.y * -1
