class_name TreeHarvestable extends Node2D

@export var max_life := 1.0

@onready var state_machine: StateMachine = $StateMachine

var life = max_life


func _ready() -> void:
	add_to_group(SaveManager.SAVEABLE_GROUP)


func get_interaction_state(tool_name: StringName) -> StringName:
	if tool_name == &"Axe":
		return &"Chop"
	
	return &""


func serialize() -> Dictionary:
	return {
		"life": life
	}


func deserialize(data: Dictionary) -> void:
	life = data.get("life", life)
	
	if life <= 0:
		state_machine.force_transitition_to("Dead")
