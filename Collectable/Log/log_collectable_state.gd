class_name LogCollectableState extends State

const WOOD = preload("uid://bcsr3v4ldyq3b")

@export var pickup_area: Area2D
@export var pickup_shape: CollisionShape2D

@onready var log_collectable: LogCollectable = get_owner()


func enter() -> void:
	pickup_shape.disabled = false
	pickup_area.body_entered.connect(_on_collect)
	log_collectable.scale = Vector2(1.2, 1.2)
	create_tween().tween_property(log_collectable, "scale", Vector2.ONE, 0.2)


func _on_collect(body: Node2D) -> void:
	if body is Player and body.has_method("collect_item"):
		body.collect_item(WOOD, 1)
		log_collectable.queue_free()
