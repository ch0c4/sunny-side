class_name PlayerMovement extends Node

@export_group("Speed Values")
@export var max_speed := 100.0
@export var acceleration_time := 0.1

@onready var player: Player = get_owner()


func _physics_process(delta: float) -> void:
	if !player.alive:
		return
	
	var velocity = player.velocity
	
	var input_direction = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	
	var target_speed = max_speed
	
	velocity = velocity.move_toward(input_direction * target_speed, (1.0 / acceleration_time) * delta * target_speed)

	if input_direction.y && sign(input_direction.y) != sign(velocity.y):
		velocity.y *= 0.5
	
	if input_direction.x && sign(input_direction.x) != sign(velocity.x):
		velocity.y *= 0.5

	player.input_direction = input_direction
	player.velocity = velocity
	player.move_and_slide()
