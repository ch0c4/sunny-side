class_name CrateFilledState extends State

@onready var crate: Crate = get_owner()

func enter() -> void:
	await get_tree().create_timer(1.0).timeout
	crate.queue_free()
