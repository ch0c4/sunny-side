class_name PlayerActionComponent extends Node

@export var state_machine: StateMachine
@export var interaction_detector: InteractionDetector

@onready var player: Player = get_owner()

var in_action: bool = false

func _ready() -> void:
	player.in_action.connect(func(in_progress):
		in_action = in_progress
	)


func _unhandled_input(event: InputEvent) -> void:
	if in_action:
		return
	
	if not event.is_action_pressed(&"interact"):
		return
	
	if player.tool_name == &"Sword":
		state_machine.force_transitition_to("Attack")
	
	var interaction := interaction_detector.get_current_interaction()
	if interaction == null:
		return
	
	var state_name := interaction.get_state_for_tool(player.tool_name)
	if state_name != &"":
		get_viewport().set_input_as_handled()
		state_machine.force_transitition_to(state_name)
