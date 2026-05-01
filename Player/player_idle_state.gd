class_name PlayerIdleState extends State


@export var animation_player: AnimationPlayer

@onready var player: Player = get_owner()


func enter() -> void:
	animation_player.play("idle")
	Events.action_selected.connect(_on_new_item_selected)


func exit() -> void:
	Events.action_selected.disconnect(_on_new_item_selected)


func physics_update(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_direction != Vector2.ZERO:
		transitionned.emit(self, "Move")
	else:
		CharacterMover.decelerate(player, player.movement_stats, delta)
		CharacterMover.move(player)


func _on_new_item_selected(_index: int, item_box: ItemBox) -> void:
	if item_box is not ItemBox:
		return
	
	if item_box.item is not Item:
		return
	
	if item_box.item.is_equipment:
		return
	else:
		transitionned.emit(self, "CarryIdle")
	
