class_name TreeChopState extends State

@export var animation_player: AnimationPlayer
@export var hurtbox: Hurtbox


func enter() -> void:
	hurtbox.is_invincible = true
	animation_player.play("chopped")
	animation_player.animation_finished.connect(_on_chopped_finished)


func exit() -> void:
	animation_player.animation_finished.disconnect(_on_chopped_finished)
	hurtbox.is_invincible = false


func _on_chopped_finished(_anim_name: StringName) -> void:
	transitionned.emit(self, "Idle")
