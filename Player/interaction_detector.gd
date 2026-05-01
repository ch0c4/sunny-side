class_name InteractionDetector extends Area2D

func trigger_interaction() -> void:
	var interactions = get_overlapping_areas()
	for interaction: Interaction in interactions:
		interaction.run()
		return

func get_current_interaction() -> Interaction:
	for area in get_overlapping_areas():
		if area is Interaction:
			return area
	
	return null


func can_interact() -> bool:
	return not get_overlapping_areas().is_empty()
