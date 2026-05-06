class_name TreeSpawnState extends State

const LOG_COLLECTABLE = preload("uid://dkyx7j0w7fpjb")

@export var spawn_shape: CollisionShape2D

@onready var tree: TreeHarvestable = get_owner()


func enter() -> void:
	var circle := spawn_shape.shape as CircleShape2D
	var offset: Vector2 = Utils.get_random_point_in_shape(circle)
	var spawn_position := spawn_shape.global_position + offset
	
	Utils.instantiate_scene_on_level(LOG_COLLECTABLE, spawn_position)
	
	await get_tree().process_frame
	if tree.life <= 0.0:
		transitionned.emit(self, "Dead")
	else:
		transitionned.emit(self, "Chop")
