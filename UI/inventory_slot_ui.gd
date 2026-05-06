class_name InventorySlotUI extends NinePatchRect

@onready var button: InventorySlotButton = $Button
@onready var label: Label = $Label

var _item_box: ItemBox
var _slot_index: int
var _inventory: Inventory


func _ready() -> void:
	button.slot_ui = self
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE


func setup(inventory: Inventory, item_box: ItemBox, index: int) -> void:
	_inventory = inventory
	_item_box = item_box
	_slot_index = index


func update_slot_icon(item_box: ItemBox) -> void:
	var item := item_box.item
	if item is Item:
		button.icon = item.icon
	else:
		button.icon = null


func update_slot_amount(item_box: ItemBox) -> void:
	if item_box is not ItemBox:
		return
	
	if item_box.item is not Item:
		label.hide()
	else:
		label.visible = not item_box.item.is_equipment
		label.text = str(item_box.amount)


func can_drop_data_on_slot(_at_position: Vector2, data: Variant) -> bool:
	if typeof(data) != TYPE_DICTIONARY:
		return false
	
	if not data.has("item_box"):
		return false
	
	return true


func get_drag_data_from_slot(_at_position: Vector2) -> Variant:
	if _item_box == null:
		return null
	
	if _item_box.item is not Item:
		return null
	
	var data := {
		"from_inventory": _inventory,
		"from_index": _slot_index,
		"item_box": _item_box
	}
	
	var preview := TextureRect.new()
	preview.texture = _item_box.item.icon
	preview.custom_minimum_size = Vector2(24.0, 24.0)
	button.set_drag_preview(preview)
	
	return data


func drop_data_on_slot(_at_position: Vector2, data: Variant) -> void:
	var _from_inventory: Inventory = data["from_inventory"]
	var _from_index: int = data["from_index"]
	print("drop -> ", data)
