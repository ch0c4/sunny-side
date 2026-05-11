class_name InventoryUI extends TabContainer

const INVENTORY_SLOT_UI = preload("uid://dpfos4aplbq3a")

@onready var items_grid: GridContainer = %Items
@onready var tools_grid: GridContainer = %Tools

@onready var items_inventory: Inventory = Stash.inventory
@onready var tools_inventory: Inventory = Stash.tools_inventory

func _ready() -> void:
	visible = false
	_clear_inventory_slots()
	_fill_items_inventory_slots()
	_fill_tools_inventory_slots()
	items_inventory.item_box_changed.connect(_on_items_inventory_item_box_changed)
	tools_inventory.item_box_changed.connect(_on_tools_inventory_item_box_changed)


func _exit_tree() -> void:
	if items_inventory.item_box_changed.is_connected(_on_items_inventory_item_box_changed):
		items_inventory.item_box_changed.disconnect(_on_items_inventory_item_box_changed)
	
	if tools_inventory.item_box_changed.is_connected(_on_tools_inventory_item_box_changed):
		tools_inventory.item_box_changed.disconnect(_on_tools_inventory_item_box_changed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		visible = !visible


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
	
	for i in range(item_boxes.size()):
		var slot_ui : InventorySlotUI = INVENTORY_SLOT_UI.instantiate()
		items_grid.add_child(slot_ui)
		
		var item_box := items_inventory.get_item_box(i)
		if item_box is ItemBox:
			slot_ui.setup(items_inventory, item_box, i)
			slot_ui.update_slot_icon(item_box)
			slot_ui.update_slot_amount(item_box)


func _fill_tools_inventory_slots() -> void:
	if tools_inventory == null:
		return
	
	var item_boxes := tools_inventory.get_item_boxes()
	if item_boxes.is_empty():
		return
	
	for i in range(item_boxes.size()):
		var slot_ui : InventorySlotUI = INVENTORY_SLOT_UI.instantiate()
		tools_grid.add_child(slot_ui)
		
		var item_box := tools_inventory.get_item_box(i)
		if item_box is ItemBox:
			slot_ui.setup(tools_inventory, item_box, i)
			slot_ui.update_slot_icon(item_box)
			slot_ui.update_slot_amount(item_box)


func _on_items_inventory_item_box_changed(item_box: ItemBox, index: int) -> void:
	var slot_ui := items_grid.get_child(index) as InventorySlotUI
	if slot_ui == null:
		return
	slot_ui.update_slot_icon(item_box)
	slot_ui.update_slot_amount(item_box)


func _on_tools_inventory_item_box_changed(item_box: ItemBox, index: int) -> void:
	var slot_ui := tools_grid.get_child(index) as InventorySlotUI
	if slot_ui == null:
		return
	slot_ui.update_slot_icon(item_box)
	slot_ui.update_slot_amount(item_box)
