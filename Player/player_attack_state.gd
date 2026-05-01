class_name PlayerAttackState extends State

const KNOCKBACK_AMOUNT := 175

@export var animation_player: AnimationPlayer
@export var tool_hitbox: Hitbox

@onready var player: Player = get_owner()


func enter() -> void:
	player.in_action.emit(true)
	animation_player.play("attack")
	animation_player.animation_finished.connect(_on_attack_finished)
	
	tool_hitbox.knockback = player.facing_direction * KNOCKBACK_AMOUNT


func exit() -> void:
	animation_player.animation_finished.disconnect(_on_attack_finished)
	tool_hitbox.clear_stores_target()
	player.in_action.emit(false)


func physics_update(delta: float) -> void:
	CharacterMover.decelerate(player, player.movement_stats, delta)
	CharacterMover.move(player)


func _on_attack_finished(_anim_name: StringName) -> void:
	transitionned.emit(self, "Idle")
