class_name CrateFillingState extends State

@export var animation_player: AnimationPlayer
@export var item_sprite: Sprite2D

@onready var crate: Crate = get_owner()

func enter() -> void:
	item_sprite.visible = true
	animation_player.play("filled")
	crate.item_box.amount_changed.connect(_on_amount_changed)


func exit() -> void:
	crate.item_box.amount_changed.disconnect(_on_amount_changed)


func _on_amount_changed() -> void:
	if crate.item_box.amount == crate.amount_condition:
		transitionned.emit(self, "Filled")
