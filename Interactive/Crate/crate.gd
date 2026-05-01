class_name Crate extends StaticBody2D

signal is_filled
signal is_fullfilled

@export_group("Condition")
@export var item_condition: Item
@export var amount_condition: int

@onready var item_info_button: Button = %ItemInfoButton
@onready var item_amount_info_label: Label = %ItemAmountInfoLabel

var item_box: ItemBox

func _ready() -> void:
	if item_condition is Item:
		item_info_button.icon = item_condition.icon
		item_box = ItemBox.new().set_item_and_amount(item_condition, 0)
		item_box.amount_changed.connect(_on_item_box_amount_changed)
		item_amount_info_label.text = str(item_box.amount) + " / " + str(amount_condition)


func place_item(item: Item, amount: int) -> int:
	if item != item_condition:
		return amount
	
	var total := item_box.amount + amount
	if total > amount_condition:
		var accepted := amount_condition - item_box.amount
		var overflow := amount - accepted
		
		if accepted > 0:
			item_box = item_box.add_item_and_amount(item, accepted)
			is_filled.emit()
		
		return overflow
	
	item_box = item_box.add_item_and_amount(item, amount)
	is_filled.emit()
	return 0


func _on_item_box_amount_changed() -> void:
	item_amount_info_label.text = str(item_box.amount) + " / " + str(amount_condition)
	if item_box.amount == amount_condition:
		is_fullfilled.emit()
		item_amount_info_label.label_settings.font_color = Color.RED
