class_name RockFirstStepState extends State

@export var animation_player: AnimationPlayer
@export var hurtbox: Hurtbox

@onready var rock_harvestable: RockHarvestable = get_owner()

func enter() -> void:
	animation_player.play("first_step")
	hurtbox.hurt.connect(_on_picked)


func exit() -> void:
	hurtbox.hurt.disconnect(_on_picked)


func _on_picked(hitbox: Hitbox) -> void:
	rock_harvestable.life -= hitbox.damage
	transitionned.emit(self, "Spawn")
