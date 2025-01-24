class_name PlayerAnimation extends Node2D


signal animation_finished

@onready var player: Player = get_owner()

@onready var base_animated_sprite: AnimatedSprite2D = %BaseSprite
@onready var hair_animated_sprite: AnimatedSprite2D = %HairSprite
@onready var tools_animated_sprite: AnimatedSprite2D = %ToolsSprite


func _ready() -> void:
	base_animated_sprite.animation_finished.connect(on_animation_finished)


func _physics_process(_delta: float) -> void:
	if !player.alive:
		return
		
	var direction = sign(player.aim_position.x) == -1
	
	base_animated_sprite.flip_h = direction
	hair_animated_sprite.flip_h = direction
	tools_animated_sprite.flip_h = direction


func play_animation(anim_name: String) -> void:
	base_animated_sprite.play(anim_name)
	hair_animated_sprite.play(anim_name + "_long")
	tools_animated_sprite.play(anim_name)


func on_animation_finished() -> void:
	animation_finished.emit()