class_name ChestOpeningState extends State

@export var animation_player: AnimationPlayer


func enter() -> void:
	animation_player.animation_finished.connect(_on_chest_opened)
	animation_player.play("opening")


func exit() -> void:
	animation_player.animation_finished.disconnect(_on_chest_opened)


func _on_chest_opened(_anim: StringName) -> void:
	transitionned.emit(self, "Open")
