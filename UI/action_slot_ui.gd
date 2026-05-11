class_name ActionSlotUI extends Button

@onready var item_button: ActionItemButton = %ItemButton
@onready var amount_label: Label = %AmountLabel

var _item_box: ItemBox
var _slot_index: int

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	amount_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	item_button.mouse_filter = Control.MOUSE_FILTER_STOP
	item_button.slot_ui = self


func setup(item_box: ItemBox, index: int) -> void:
	_item_box = item_box
	_slot_index = index


func update_slot_icon(item_box: ItemBox) -> void:
	var item := item_box.item
	if item is Item:
		item_button.icon = item.icon
	else:
		item_button.icon = null


func update_slot_amount(item_box: ItemBox) -> void:
	if item_box is not ItemBox:
		return
	
	if item_box.item is not Item:
		amount_label.hide()
	else:
		amount_label.visible = not item_box.item.is_equipment
		amount_label.text = str(item_box.amount)


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
		"from_inventory": Stash.action_inventory,
		"from_index": _slot_index,
		"item_box": _item_box
	}
	
	var preview := TextureRect.new()
	preview.texture = _item_box.item.icon
	preview.custom_minimum_size = Vector2(32.0, 32.0)
	set_drag_preview(preview)
	
	return data


func on_double_click() -> void:
	if _item_box == null or _item_box.item is not Item:
		return
	
	var target: Inventory = Stash.tools_inventory if _item_box.item.is_equipment else Stash.inventory
	if target.is_full() and not target.has_item(_item_box.item):
		return
	
	target.add_item(_item_box.item, _item_box.amount)
	Stash.action_inventory.clear_item_box(_slot_index)


func drop_data_on_slot(_at_position: Vector2, data: Variant) -> void:
	var from_inventory: Inventory = data["from_inventory"]
	var from_index: int = data["from_index"]
	var from_item_box: ItemBox = data["item_box"]
	
	var to_item := _item_box.item
	var to_amount := _item_box.amount
	
	Stash.action_inventory.set_item_box(_slot_index, from_item_box.item, from_item_box.amount)
	
	if to_item is Item:
		from_inventory.set_item_box(from_index, to_item, to_amount)
	else:
		from_inventory.clear_item_box(from_index)
