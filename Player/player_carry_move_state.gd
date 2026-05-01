class_name PlayerCarryMoveState extends State

@export var animation_player: AnimationPlayer
@export var interaction_detector: InteractionDetector

@onready var player: Player = get_owner()


func enter() -> void:
	animation_player.play("carry")
	Events.action_selected.connect(_on_new_item_selected)


func exit() -> void:
	Events.action_selected.disconnect(_on_new_item_selected)


func physics_update(delta: float) -> void:
	
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_direction == Vector2.ZERO:
		transitionned.emit(self, "CarryIdle")
	else:
		CharacterMover.accelerate_in_direction(player, input_direction, player.movement_stats, delta)
		CharacterMover.move(player)
	
	_manage_interaction()


func _manage_interaction() -> void:
	if not Input.is_action_just_pressed(&"interact"):
		return
	
	if not interaction_detector.can_interact():
		return
	
	var interaction: Interaction= interaction_detector.get_current_interaction()
	if interaction == null:
		return
			
	var interaction_parent_node: Crate = interaction.parent_node
	if interaction_parent_node is not Crate:
		return
	
	if interaction_parent_node.item_condition != player.selected_action_item:
		return
	
	var action_inventory := player.action_inventory
	var item_box := action_inventory.get_item_box(player.selected_action_index)
	if item_box == null or item_box.is_empty():
		return
	
	var item_to_place := item_box.item
	var amount_to_place := item_box.amount
	
	var overflow := interaction_parent_node.place_item(item_to_place, amount_to_place)
	var placed := amount_to_place - overflow
	
	if placed <= 0:
		return
	
	action_inventory.remove_item(item_to_place, placed)
	
	if not action_inventory.has_item(item_to_place):
		transitionned.emit(self, "Move")


func _on_new_item_selected(_index: int, item_box: ItemBox) -> void:
	if item_box is not ItemBox:
		return
	
	if item_box.item is not Item:
		return
	
	if item_box.item.is_equipment:
		transitionned.emit(self, "Move")
