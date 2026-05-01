class_name InventoryUI extends TabContainer

const INVENTORY_SLOT_UI = preload("uid://dpfos4aplbq3a")

@onready var tools_grid: GridContainer = $Tools
@onready var items_grid: GridContainer = $Items

@onready var items_inventory: Inventory = Stash.inventory
@onready var tools_inventory: Inventory = Stash.tools_inventory

func _ready() -> void:
	visible = false
	_clear_inventory_slots()
	_fill_items_inventory_slots()
	_fill_tools_inventory_slots()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible


func update_item_inventory_slot_ui_item(index: int, item_box: ItemBox) -> void:
	if index < 0 or index >= items_inventory.get_item_boxes().size():
		return
	
	var inventory_slot_ui: InventorySlotUI = items_grid.get_child(index)
	inventory_slot_ui.update_slot_icon(item_box)
	inventory_slot_ui.update_slot_amount(item_box)


func update_tool_inventory_slot_ui_item(index: int, item_box: ItemBox) -> void:
	if index < 0 or index >= tools_inventory.get_item_boxes().size():
		return
	
	var inventory_slot_ui: InventorySlotUI = tools_grid.get_child(index)
	inventory_slot_ui.update_slot_icon(item_box)
	inventory_slot_ui.update_slot_amount(item_box)


func _clear_inventory_slots() -> void:
	for child in items_grid.get_children():
		child.queue_free()
	
	for child in tools_grid.get_children():
		child.queue_free()


func _fill_items_inventory_slots() -> void:
	if items_inventory == null:
		return
	
	var item_boxes := items_inventory.get_item_boxes()
	if item_boxes.is_empty():
		return
	
	for i in range(0, 14):
		items_grid.add_child(INVENTORY_SLOT_UI.instantiate())
		var item_box := items_inventory.get_item_box(i)
		if item_box is ItemBox:
			update_item_inventory_slot_ui_item(i, item_box)


func _fill_tools_inventory_slots() -> void:
	if tools_inventory == null:
		return
	
	var item_boxes := tools_inventory.get_item_boxes()
	if item_boxes.is_empty():
		return
	
	for i in range(0, 14):
		items_grid.add_child(INVENTORY_SLOT_UI.instantiate())
		var item_box := tools_inventory.get_item_box(i)
		if item_box is ItemBox:
			update_tool_inventory_slot_ui_item(i, item_box)
