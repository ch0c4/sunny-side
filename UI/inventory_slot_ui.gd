class_name InventorySlotUI extends NinePatchRect

@onready var button: Button = $Button
@onready var label: Label = $Label


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
