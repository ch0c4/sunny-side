class_name TreeDeadState extends State

const TRUNK = preload("uid://b1fbofurtvlgy")

@onready var tree: TreeHarvestable = get_owner()

func enter() -> void:
	tree.call_deferred("queue_free")
	Utils.instantiate_scene_on_level(TRUNK, tree.global_position)
