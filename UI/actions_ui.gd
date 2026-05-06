class_name ActionsUI extends HBoxContainer

@onready var _action_slots: Array[ActionSlotUI] = [
	%ActionSlotUI1,
	%ActionSlotUI2,
	%ActionSlotUI3,
	%ActionSlotUI4
]

@onready var action_inventory: Inventory = Stash.action_inventory

var current_index := 0


func _exit_tree() -> void:
	if action_inventory.item_box_changed.is_connected(_on_action_inventory_item_box_changed):
		action_inventory.item_box_changed.disconnect(_on_action_inventory_item_box_changed)


func _ready() -> void:
	action_inventory.item_box_changed.connect(_on_action_inventory_item_box_changed)
	
	_bind_focus_signals()
	_fill_slots_from_inventory()
	select_slot(0)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			select_previous_slot()
			get_viewport().set_input_as_handled()
			return
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			select_next_slot()
			get_viewport().set_input_as_handled()
			return
	
	if event.is_action_pressed("hotbar_slot_1"):
		select_slot(0)
		get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed("hotbar_slot_2"):
		select_slot(1)
		get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed("hotbar_slot_3"):
		select_slot(2)
		get_viewport().set_input_as_handled()
		return
	
	if event.is_action_pressed("hotbar_slot_4"):
		select_slot(3)
		get_viewport().set_input_as_handled()
		return


func select_next_slot() -> void:
	if _action_slots.is_empty():
		return
	
	var next_index := wrapi(current_index + 1, 0, _action_slots.size())
	select_slot(next_index)


func select_previous_slot() -> void:
	if _action_slots.is_empty():
		return
	
	var previous_index := wrapi(current_index - 1, 0, _action_slots.size())
	select_slot(previous_index)


func select_slot(index: int) -> void:
	if _action_slots.is_empty():
		return
	
	if index < 0 or index >= _action_slots.size():
		return
	
	current_index = index
	
	var slot := _action_slots[index]
	if is_instance_valid(slot):
		slot.grab_focus()
	
	_emit_selected_action()


func update_action_slot_ui_item(index: int, item_box: ItemBox) -> void:
	if index < 0 or index >= _action_slots.size():
		return
	
	var action_slot_ui: ActionSlotUI = _action_slots[index]
	action_slot_ui.setup(item_box, index)
	action_slot_ui.update_slot_icon(item_box)
	action_slot_ui.update_slot_amount(item_box)


func _emit_selected_action() -> void:
	if action_inventory == null:
		Events.action_selected.emit(current_index, null)
		return
	
	var item_box: ItemBox = action_inventory.get_item_box(current_index)
	Events.action_selected.emit(current_index, item_box)


func _fill_slots_from_inventory() -> void:
	if action_inventory == null:
		return
	
	var item_boxes := action_inventory.get_item_boxes()
	if item_boxes.is_empty():
		return
	
	var count: int = min(_action_slots.size(), item_boxes.size())
	for i in range(count):
		var item_box := action_inventory.get_item_box(i)
		if item_box is ItemBox:
			update_action_slot_ui_item(i, item_box)


func _bind_focus_signals() -> void:
	for i in range(_action_slots.size()):
		var slot := _action_slots[i]
		slot.focus_entered.connect(_on_action_slot_focus_entered.bind(i))


func _on_action_slot_focus_entered(index: int) -> void:
	current_index = index
	_emit_selected_action()


func _on_action_inventory_item_box_changed(item_box: ItemBox, item_box_index: int) -> void:
	if item_box_index < 0 or item_box_index >= _action_slots.size():
		return
	
	update_action_slot_ui_item(item_box_index, item_box)
