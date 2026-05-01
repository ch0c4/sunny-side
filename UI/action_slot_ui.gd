class_name ActionSlotUI extends Button

@onready var item_button: Button = %ItemButton
@onready var amount_label: Label = %AmountLabel


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
