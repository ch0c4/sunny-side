extends Node


func instantiate_scene_on_level(scene: PackedScene, global_pos: Vector2) -> Node:
	var node := scene.instantiate()
	return instantiate_node_on_level(node, global_pos)


func instantiate_node_on_level(node: Node, global_pos: Vector2) -> Node:
	var main := get_tree().current_scene as World
	
	if main is World:
		main.call_deferred("add_child", node)
		node.set_deferred("global_position", global_pos)
	
	return node


func get_random_point_in_shape(shape: CircleShape2D) -> Vector2:
	var angle := randf() * TAU
	var distance := sqrt(randf()) * shape.radius
	return Vector2(cos(angle), sin(angle)) * distance
