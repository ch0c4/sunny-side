class_name Skeleton extends CharacterBody2D

@export var movement_stats: MovementStats
@export var stats: Stats
@export var aggro_range: float = 80.0
@export var attack_range: float = 18.0
@export var knockback_amount: float = 150.0
@export var patrol_points: Array[Marker2D] = []
@export var patrol_wait_time: float = 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var weapon_hitbox: Hitbox = $WeaponHitbox
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_machine: StateMachine = $StateMachine

var last_hitbox: Hitbox = null


func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)


func _on_hurt(hitbox: Hitbox) -> void:
	if stats.is_health_gone():
		return
	
	last_hitbox = hitbox
	stats.health -= hitbox.damage
	
	if stats.is_health_gone():
		state_machine.force_transitition_to("Death")
	else:
		state_machine.force_transitition_to("Hurt")
