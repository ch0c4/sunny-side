class_name InventorySlotButton extends Button

var slot_ui: InventorySlotUI


func _get_drag_data(at_position: Vector2) -> Variant:
	return slot_ui.get_drag_data_from_slot(at_position)


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return slot_ui.can_drop_data_on_slot(at_position, data)


func _drop_data(at_position: Vector2, data: Variant) -> void:
	slot_ui.drop_data_on_slot(at_position, data)
