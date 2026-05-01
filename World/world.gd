class_name World extends Node2D

@export var current_level: Level
@onready var player: Player = $Player

func _ready() -> void:
	y_sort_enabled = true
	RenderingServer.set_default_clear_color(Color(0.1, 0.1, 0.1))
	Events.transition_entered.connect(change_levels, CONNECT_DEFERRED)


func set_level(level_scene_path: String) -> void:
	if current_level != null:
		SaveManager.save_current_level(current_level)
		current_level.queue_free()
		
	var new_level: Level = load(level_scene_path).instantiate()
	current_level = new_level
	add_child(new_level)
	
	await get_tree().process_frame
	SaveManager.load_level(current_level)


func change_levels(entered_transition: Transition) -> void:
	if player is not Player:
		return
	
	var entered_connection := entered_transition.connection
	var entered_offset := entered_transition.get_offset(player)
	var next_level_path = entered_transition.next_level_path
	
	await set_level(entered_transition.next_level_path)
	
	var transitions := get_tree().get_nodes_in_group("transitions")
	
	for transition: Transition in transitions:
		if transition.connection != entered_connection:
			continue
		
		player.global_position = transition.get_exit_point() - entered_offset
		Events.request_camera_target.emit(player.camera_anchor)
		break
