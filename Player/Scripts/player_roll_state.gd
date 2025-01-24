extends State

@export var player_animation: PlayerAnimation

@onready var player: Player = get_owner()


func enter() -> void:
    if player_animation:
        player_animation.play_animation("roll")
        player_animation.animation_finished.connect(on_animation_finished)


func exit() -> void:
    player_animation.animation_finished.disconnect(on_animation_finished)


func on_animation_finished() -> void:
    if player.input_direction == Vector2.ZERO:
        transitionned.emit(self, "idle")
    else:
        transitionned.emit(self, "walking")
