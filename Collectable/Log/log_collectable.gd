class_name LogCollectable extends Node2D

@onready var pickup_shape: CollisionShape2D = %PickupShape


func _ready() -> void:
	pickup_shape.disabled = true
