class_name Player extends CharacterBody2D

@warning_ignore("unused_signal")
signal in_action(in_progress: bool)

@export var stats: Stats
@export var movement_stats: MovementStats

@onready var tool_hitbox: Hitbox = %ToolHitbox
@onready var camera_anchor: RemoteTransform2D = $CameraAnchor

@onready var inventory: Inventory = Stash.inventory
@onready var action_inventory: Inventory = Stash.action_inventory
@onready var tools_inventory: Inventory = Stash.tools_inventory

var selected_action_index: int = 0
var selected_action_item: Item = null:
	set(value):
		selected_action_item = value
		if value is Item:
			tool_name = selected_action_item.name
var tool_name: String

var facing_direction := Vector2.RIGHT

func _enter_tree() -> void:
	MainInstance.player = self


func _exit_tree() -> void:
	MainInstance.player = null
	
	if Events.action_selected.is_connected(_on_action_selected):
		Events.action_selected.disconnect(_on_action_selected)


func _ready() -> void:
	add_to_group(SaveManager.SAVEABLE_GROUP)
	Events.request_camera_target.emit.call_deferred(camera_anchor)
	Events.action_selected.connect(_on_action_selected)
	
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	var item_box: ItemBox = action_inventory.get_item_box(selected_action_index)
	_on_action_selected(selected_action_index, item_box)


func collect_item(item: Item, amount: int) -> void:
	if action_inventory.is_full():
		if item.is_equipment and not tools_inventory.is_full():
			tools_inventory.add_item(item, amount)
		elif not item.is_equipment and not inventory.is_full():
			inventory.add_item(item, amount)
	else:
		action_inventory.add_item(item, amount)


func _on_action_selected(index: int, item_box: ItemBox) -> void:
	selected_action_index = index
	selected_action_item = null

	if item_box == null or item_box.item == null or item_box.item is not Item:
		return

	selected_action_item = item_box.item


func serialize() -> Dictionary:
	return {
		"global_position": {
			"x": global_position.x,
			"y": global_position.y
		}
	}


func deserialize(data: Dictionary) -> void:
	var pos: Dictionary = data.get("global_position", {})
	global_position = Vector2(
		pos.get("x", global_position.x),
		pos.get("y", global_position.y)
	)
	Events.request_camera_target.emit(camera_anchor)
