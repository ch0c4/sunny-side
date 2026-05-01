class_name Stats extends Resource

signal max_health_changed(new_max_health)
signal health_changed(new_health)
signal no_health()

@export var max_health: = 1.0 :
	set(value):
		var change: = value - max_health
		max_health = value
		health = max_health
		if change != 0: 
			max_health_changed.emit(max_health)

var health: = max_health :
	set(value):
		var change: = value - health
		health = clamp(value, 0, max_health)
		if change != 0: 
			health_changed.emit(health)
		if is_health_gone(): 
			no_health.emit()


func is_health_gone() -> bool:
	return (health <= 0)


func serialize() -> Dictionary:
	var data: = {}
	data.health = health
	data.max_health = max_health
	return data


func deserialize(data: Dictionary) -> Stats:
	max_health = data.max_health
	health = data.health
	return self
