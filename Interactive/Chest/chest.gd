class_name Chest extends StaticBody2D

@export var item: Item
@export var amount: int


func get_interaction_state(_tool_name: StringName) -> StringName:
	return &"Doing"
