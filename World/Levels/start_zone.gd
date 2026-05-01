class_name StartZone extends Level

@onready var invisible_wall_shape: CollisionShape2D = $InvisibleWallWithCondition/CollisionShape2D
@onready var crate: Crate = $Crate

var condition_fullfilled := false

func _ready() -> void:
	super._ready()
	add_to_group(SaveManager.SAVEABLE_GROUP)
	
	invisible_wall_shape.disabled = false
	crate.is_fullfilled.connect(_on_fullfilled_crate)


func _on_fullfilled_crate() -> void:
	invisible_wall_shape.disabled = true
	condition_fullfilled = true
	crate.queue_free()


func serialize() -> Dictionary:
	return {
		"condition_fullfilled": condition_fullfilled
	}


func deserialize(data: Dictionary) -> void:
	condition_fullfilled = data.get("condition_fullfilled", false)
	
	if condition_fullfilled:
		invisible_wall_shape.disabled = true
		if crate != null:
			crate.queue_free()
