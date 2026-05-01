class_name Hitbox extends Area2D

signal hit_hurtbox(hurtbox: Hurtbox)

@export var damage: = 1.0
@export var is_storing_targets: bool = false

var knockback: = Vector2.ZERO
var stored_targets := []

func _ready() -> void:
	area_entered.connect(_on_hurtbox_entered)


func clear_stores_target() -> void:
	stored_targets.clear()


func _on_hurtbox_entered(hurtbox: Hurtbox) -> void:
	assert(hurtbox is Hurtbox, "Your hitbox is colliding with an area that isn't an hurtbox!")
	
	if hurtbox.is_invincible: 
		return
	
	if is_storing_targets:
		if hurtbox in stored_targets:
			return
		else:
			stored_targets.append(hurtbox)
	
	hit_hurtbox.emit(hurtbox)
	hurtbox.hurt.emit(self)
