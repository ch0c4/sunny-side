class_name PlayerInventoryManager extends Control

@onready var actions_ui: ActionsUI = $ActionsUI
@onready var inventory_ui: InventoryUI = $InventoryUI


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print(at_position)
	print(data)
	return false


func _get_drag_data(at_position: Vector2) -> Variant:
	print(at_position)
	return null


func _drop_data(at_position: Vector2, data: Variant) -> void:
	print(at_position)
	print(data)
