class_name PlayerInventoryManager extends Control

@onready var actions_ui: ActionsUI = $ActionsUI
@onready var inventory_ui: InventoryUI = $InventoryUI


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
