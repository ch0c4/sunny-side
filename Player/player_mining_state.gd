class_name PlayerMiningState extends State

@export var animation_player: AnimationPlayer
@export var tool_hitbox: Hitbox

@onready var player: Player = get_owner()


func enter() -> void:
	animation_player.play("mining")
	animation_player.animation_finished.connect(_on_mining_finished)
	player.in_action.emit(true)


func exit() -> void:
	animation_player.animation_finished.disconnect(_on_mining_finished)
	tool_hitbox.clear_stores_target()
	player.in_action.emit(false)


func physics_update(delta: float) -> void:
	CharacterMover.decelerate(player, player.movement_stats, delta)
	CharacterMover.move(player)


func _on_mining_finished(_anim_name: StringName) -> void:
	transitionned.emit(self, "Idle")
