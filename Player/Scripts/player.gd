class_name Player extends CharacterBody2D

var alive := true

var input_direction: Vector2 = Vector2.ZERO
var aim_position: Vector2 = Vector2(1, 0)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var half_viewport = get_viewport_rect().size / 2.0
        aim_position = (event.position - half_viewport)