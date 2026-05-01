class_name RockDeadState extends State

@onready var rock: RockHarvestable = get_owner()

func enter() -> void:
	rock.call_deferred("queue_free")
