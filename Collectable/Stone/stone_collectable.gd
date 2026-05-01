@tool
class_name StoneCollectable extends Node2D

@export var stone_type: Constants.ROCK_TYPE = Constants.ROCK_TYPE.ROCK: 
	set(value):
		stone_type = value
		update_stone_type()

@onready var stone_sprite: Sprite2D = $StoneSprite
@onready var pickup_shape: CollisionShape2D = $PickupArea/PickupShape

var stone_region: Dictionary = {
	Constants.ROCK_TYPE.ROCK: 		Rect2(880.0, 480.0, 16.0, 16.0),
	Constants.ROCK_TYPE.GOLD: 		Rect2(880.0, 448.0, 16.0, 16.0),
	Constants.ROCK_TYPE.COAL: 		Rect2(880.0, 384.0, 16.0, 16.0),
	Constants.ROCK_TYPE.DIAMOND: 	Rect2(880.0, 416.0, 16.0, 16.0),
	Constants.ROCK_TYPE.SILVER: 	Rect2(880.0, 352.0, 16.0, 16.0)
}

var collectable: Dictionary = {
	Constants.ROCK_TYPE.ROCK: 		preload("uid://c2l7wiaqqfe4t"),
	Constants.ROCK_TYPE.GOLD: 		preload("uid://dm04golti0hdf"),
	Constants.ROCK_TYPE.COAL: 		preload("uid://b25w6li5jsxn"),
	Constants.ROCK_TYPE.DIAMOND: 	preload("uid://by7ajox0bi5kn"),
	Constants.ROCK_TYPE.SILVER: 	preload("uid://df4bu41p5acl0")
}


func update_stone_type() -> void:
	if not is_node_ready():
		return
	
	if stone_sprite == null:
		return
	
	stone_sprite.region_enabled = true
	stone_sprite.region_rect = stone_region[stone_type]
	queue_redraw()


func _ready() -> void:
	pickup_shape.disabled = true
