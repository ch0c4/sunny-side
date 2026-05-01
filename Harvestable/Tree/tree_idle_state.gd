class_name TreeIdleState extends State

@export var hurtbox: Hurtbox
@export var animation_player: AnimationPlayer

@onready var tree: TreeHarvestable = get_owner()


func enter() -> void:
	animation_player.play("idle")
	hurtbox.hurt.connect(_on_hurt)


func exit() -> void:
	hurtbox.hurt.disconnect(_on_hurt)


func _on_hurt(hitbox: Hitbox) -> void:
	tree.life -= hitbox.damage
	transitionned.emit(self, "Spawn")
