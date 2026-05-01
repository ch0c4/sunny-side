@tool
class_name RockHarvestable extends Node2D

@export var rock_type: Constants.ROCK_TYPE = Constants.ROCK_TYPE.ROCK:
	set(value):
		rock_type = value
		update_rock_type()
@export var max_life := 3.0

@onready var rock_sprite: Sprite2D = $RockSprite
@onready var state_machine: StateMachine = $StateMachine

var life := max_life
var life_percent:
	get:
		if max_life == 0:
			return 0.0
		return clamp((life / max_life) * 100.0, 0.0, 100.0)

var rock_region: Dictionary = {
	Constants.ROCK_TYPE.ROCK: 		Rect2(784.0, 464.0, 96.0, 32.0),
	Constants.ROCK_TYPE.GOLD: 		Rect2(784.0, 432.0, 96.0, 32.0),
	Constants.ROCK_TYPE.COAL: 		Rect2(784.0, 368.0, 96.0, 32.0),
	Constants.ROCK_TYPE.DIAMOND: 	Rect2(784.0, 400.0, 96.0, 32.0),
	Constants.ROCK_TYPE.SILVER: 	Rect2(784.0, 336.0, 96.0, 32.0)
}


func update_rock_type() -> void:
	if not is_node_ready():
		return
	
	if rock_sprite == null:
		return
	
	rock_sprite.region_enabled = true
	rock_sprite.region_rect = rock_region[rock_type]
	queue_redraw()


func _ready() -> void:
	add_to_group(SaveManager.SAVEABLE_GROUP)
	update_rock_type()


func get_interaction_state(tool_name: StringName) -> StringName:
	if tool_name == &"Pickaxe":
		return &"Mining"
	
	return &""


func serialize() -> Dictionary:
	return {
		"rock_type": rock_type,
		"life": life
	}


func deserialize(data: Dictionary) -> void:
	rock_type = data.get("rock_type")
	life = data.get("life")
	
	if life_percent <= 0.0:
		state_machine.force_transitition_to("Dead")
	elif life_percent >= 100.0:
		state_machine.force_transitition_to("Full")
	elif life_percent >= 50.0:
		state_machine.force_transitition_to("FirstStep")
	else:
		state_machine.force_transitition_to("SecondStep")
