class_name FlipComponent extends Node2D

@export var player_body: PlayerBody

@onready var player: Player = get_owner()

var in_action: bool = false

func _ready() -> void:
	player.in_action.connect(func(value):
		in_action = value
	)


func _process(_delta: float) -> void:
	if in_action:
		return
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var direction: float = sign(mouse_pos.x - player_body.global_position.x)
	player.facing_direction = mouse_pos - player_body.global_position
	
	if direction != 0 and player_body.scale.x != direction:
		player_body.scale.x = direction
