class_name ItemBox extends RefCounted

const MIN_ITEM_STACK: = 0
const MAX_ITEM_STACK: = 99

signal item_changed()
signal amount_changed()

var item: Item :
	set(value):
		item = value
		item_changed.emit()

var amount: int = 0 :
	set(value):
		amount = clamp(value, MIN_ITEM_STACK, MAX_ITEM_STACK)
		if amount == 0:
			item = null
		amount_changed.emit()


func set_item_and_amount(new_item: Item, new_amount := 1) -> ItemBox:
	item = new_item
	amount = new_amount
	return self


func add_item_and_amount(add_item: Item, add_amount := 1) -> ItemBox:
	if add_item is not Item:
		item = add_item
	
	amount = amount + add_amount
	return self


func is_empty() -> bool:
	return item is not Item and amount <= 0


func serialize() -> Dictionary:
	var data: = {}
	if item is Item:
		data.item_path = item.resource_path
		data.amount = amount
	return data


func deserialize(data: Dictionary) -> ItemBox:
	if data.has("item_path"):
		var loaded_item: = load(data.item_path)
		item = loaded_item
		amount = data.amount
	return self
