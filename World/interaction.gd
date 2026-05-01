class_name Interaction extends Area2D

const INTERACTION_LAYER_NUMBER: = 6

signal interacted

@export var sprite: Sprite2D

@onready var select_sprite: Sprite2D = $SelectSprite
@onready var parent_node := get_owner()


func _exit_tree() -> void:
	if mouse_entered.is_connected(toggle_highlight):
		mouse_entered.disconnect(toggle_highlight)
	
	if mouse_exited.is_connected(toggle_highlight):
		mouse_exited.disconnect(toggle_highlight)


func _ready() -> void:
	mouse_entered.connect(toggle_highlight.bind(true))
	mouse_exited.connect(toggle_highlight.bind(false))
	
	select_sprite.visible = false
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(INTERACTION_LAYER_NUMBER, true)


func get_state_for_tool(tool_name: StringName) -> StringName:
	if parent_node != null and parent_node.has_method("get_interaction_state"):
		return parent_node.get_interaction_state(tool_name)
	
	return &""


func run() -> void:
	interacted.emit()


func toggle_highlight(on: bool) -> void:
	sprite.modulate.a = 0.8 if on else 1.0
	select_sprite.visible = on
