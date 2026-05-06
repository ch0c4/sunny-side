class_name RockSpawnState extends State

const STONE_COLLECTABLE = preload("uid://decx7i1uu14ja")

@export var spawn_shape: CollisionShape2D

@onready var rock: RockHarvestable = get_owner()


func enter() -> void:
	var circle := spawn_shape.shape as CircleShape2D
	var offset: Vector2 = Utils.get_random_point_in_shape(circle)
	var spawn_position := spawn_shape.global_position + offset
	
	var stone_collectable: StoneCollectable = Utils.instantiate_scene_on_level(STONE_COLLECTABLE, spawn_position)
	stone_collectable.stone_type = rock.rock_type
	await get_tree().process_frame
	stone_collectable.update_stone_type()
	
	
	var percent = rock.life_percent
	if percent <= 0.0:
		transitionned.emit(self, "Dead")
	elif percent >= 100.0:
		transitionned.emit(self, "Full")
	elif percent >= 50.0:
		transitionned.emit(self, "FirstStep")
	else:
		transitionned.emit(self, "SecondStep")
