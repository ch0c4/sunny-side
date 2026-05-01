@tool
class_name PlayerBody extends Node2D


@export var base_texture: Texture2D: set = set_base_texture
@export var hair_texture: Texture2D: set = set_hair_texture
@export var tool_texture: Texture2D: set = set_tool_texture

@export var animation_hframes: int = 1: set = set_animation_hframes
@export var animation_vframes: int = 1: set = set_animation_vframes
@export var animation_frame: int = 0: set = set_animation_frame

@onready var base_sprite: Sprite2D = $BaseSprite
@onready var hair_sprite: Sprite2D = $HairSprite
@onready var tool_sprite: Sprite2D = $ToolSprite

func _ready() -> void:
	if not is_instance_valid(base_sprite):
		return
	
	base_sprite.texture = base_texture
	hair_sprite.texture = hair_texture
	tool_sprite.texture = tool_texture
	
	base_sprite.hframes = animation_hframes
	hair_sprite.hframes = animation_hframes
	tool_sprite.hframes = animation_hframes
	
	base_sprite.vframes = animation_vframes
	hair_sprite.vframes = animation_vframes
	tool_sprite.vframes = animation_vframes
	
	base_sprite.frame = animation_frame
	hair_sprite.frame = animation_frame
	tool_sprite.frame = animation_frame
	


func set_base_texture(value: Texture2D) -> void:
	base_texture = value
	if is_instance_valid(base_sprite):
		base_sprite.texture = value


func set_hair_texture(value: Texture2D) -> void:
	hair_texture = value
	if is_instance_valid(hair_sprite):
		hair_sprite.texture = value


func set_tool_texture(value: Texture2D) -> void:
	tool_texture = value
	if is_instance_valid(tool_sprite):
		tool_sprite.texture = value


func set_animation_hframes(value: int) -> void:
	animation_hframes = value
	if is_instance_valid(base_sprite):
		base_sprite.hframes = value
		hair_sprite.hframes = value
		tool_sprite.hframes = value


func set_animation_vframes(value: int) -> void:
	animation_vframes = value
	if is_instance_valid(base_sprite):
		base_sprite.vframes = value
		hair_sprite.vframes = value
		tool_sprite.vframes = value


func set_animation_frame(value: int) -> void:
	animation_frame = value
	if is_instance_valid(base_sprite):
		base_sprite.frame = value
		hair_sprite.frame = value
		tool_sprite.frame = value
