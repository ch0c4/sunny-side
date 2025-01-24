extends State


@onready var player: Player = get_owner()

@export var player_animation: PlayerAnimation


func enter() -> void:
    if player_animation:
        player_animation.animation_finished.connect(on_animation_finished)
        player_animation.play_animation("attack")


func exit() -> void:
    player_animation.animation_finished.disconnect(on_animation_finished)


func physics_update(_delta: float) -> void:
    player.velocity = Vector2.ZERO


func on_animation_finished() -> void:
    transitionned.emit(self, "idle")
