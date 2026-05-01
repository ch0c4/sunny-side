class_name CrateEmptyState extends State

@export var animation_player: AnimationPlayer
@export var item_sprite: Sprite2D

@onready var crate: Crate = get_owner()


func enter() -> void:
	crate.is_filled.connect(_on_filled_crate)
	item_sprite.visible = false
	animation_player.play("empty")


func exit() -> void:
	crate.is_filled.disconnect(_on_filled_crate)


func _on_filled_crate() -> void:
	transitionned.emit(self, "Filling")
