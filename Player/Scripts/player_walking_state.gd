extends State


@export var player_animation: PlayerAnimation
@export var player_movement: PlayerMovement

@onready var player: Player = get_owner()


func enter() -> void:
    if player_animation:
        player_animation.play_animation("walking")
    
    if player_movement:
        player_movement.max_speed = 100.0
        player_movement.acceleration_time = 0.1


func physics_update(_delta: float) -> void:
    if player.velocity == Vector2.ZERO:
        transitionned.emit(self, "idle")
    
    if Input.is_action_pressed("run"):
        transitionned.emit(self, "run")
    
    if Input.is_action_just_pressed("action"):
        transitionned.emit(self, "attack")
    
    if Input.is_action_just_pressed("roll"):
        transitionned.emit(self, "roll")