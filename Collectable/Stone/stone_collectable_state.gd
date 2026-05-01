class_name StoneCollectableState extends State

@export var pickup_area: Area2D
@export var pickup_shape: CollisionShape2D

@onready var stone_collectable: StoneCollectable = get_owner()

func enter() -> void:
	pickup_shape.disabled = false
	pickup_area.body_entered.connect(_on_collect)
	stone_collectable.scale = Vector2(1.2, 1.2)
	create_tween().tween_property(stone_collectable, "scale", Vector2.ONE, 0.2)


func _on_collect(body: Node2D) -> void:
	if body is Player and body.has_method("collect_item"):
		var c = stone_collectable.collectable[stone_collectable.stone_type]
		body.collect_item(c, 1)
		stone_collectable.queue_free()
