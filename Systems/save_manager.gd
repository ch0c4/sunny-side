extends Node

const TEST_PATH := "res://sunny_side_save.json"
const SAVE_PATH := "users://sunny_side_save.json"
const SAVEABLE_GROUP := "saveable"

var save_path := TEST_PATH
var save_data := {
	"levels": {},
	"player": {},
	"stash": {}
}


func save_game(world: World) -> void:
	if world == null:
		return
	
	_load_save_file()

	save_current_level(world.current_level)
	save_player(world.player)
	save_stash()


func save_current_level(level: Level) -> void:
	if level == null:
		return
	
	print("save_current_level")
	
	var level_path := level.scene_file_path
	if level_path == "":
		return

	save_data["levels"][level_path] = {}
	
	if level.has_method("serialize"):
		save_data["levels"][level_path]["data"] = level.serialize()

	for node: Node in get_tree().get_nodes_in_group(SAVEABLE_GROUP):
		if not level.is_ancestor_of(node):
			continue
		
		if not node.has_method("serialize"):
			continue
		
		var local_path := str(level.get_path_to(node))
		save_data["levels"][level_path][local_path] = node.serialize()
	
	_write_save_file()


func load_level(level: Level) -> void:
	if level == null:
		return
	
	_load_save_file()

	var level_path := level.scene_file_path
	var level_data: Dictionary = save_data.get("levels", {}).get(level_path, {})
	
	if level.has_method("deserialize"):
		level.deserialize(level_data["data"])

	for node: Node in get_tree().get_nodes_in_group(SAVEABLE_GROUP):
		if not level.is_ancestor_of(node):
			continue
		
		if not node.has_method("deserialize"):
			continue
		
		var local_path := str(level.get_path_to(node))

		if level_data.has(local_path):
			node.deserialize(level_data[local_path])


func save_player(player: Player) -> void:
	if player == null:
		return
	
	save_data["player"] = player.serialize()
	
	_write_save_file()


func load_player(player: Player) -> void:
	if player == null:
		return
	
	_load_save_file()

	var player_data = save_data.get("player", {})
	if not player_data.empty():
		player.deserialize(player_data)



func save_stash() -> void:
	save_data["stash"] = {
		"inventory": Stash.inventory.serialize(),
		"action_inventory": Stash.action_inventory.serialize()
	}
	_write_save_file()


func load_stash() -> void:
	_load_save_file()
	var stash_data = save_data.get("stash", {})

	if stash_data.has("inventory"):
		Stash.inventory = Inventory.new().deserialize(stash_data["inventory"])
	
	if stash_data.has("action_inventory"):
		Stash.action_inventory = Inventory.new().deserialize(stash_data["action_inventory"])


func _write_save_file() -> void:
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file for writing.")
		return
	
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()


func _load_save_file() -> void:
	if not _has_save_file():
		save_data = {
			"levels": {},
			"player": {},
			"stash": {}
		}
		return
	
	var file := FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		return
	
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(parsed) == TYPE_DICTIONARY:
		save_data = parsed
	
	if not save_data.has("levels"):
		save_data["levels"] = {}
	
	if not save_data.has("player"):
		save_data["player"] = {}
	
	if not save_data.has("stash"):
		save_data["stash"] = {}


func _delete_save_file() -> void:
	if _has_save_file():
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	
	save_data = {
		"levels": {},
		"player": {},
		"stash": {}
	}


func _has_save_file() -> bool:
	return FileAccess.file_exists(save_path)
