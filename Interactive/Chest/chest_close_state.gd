class_name ChestCloseState extends State

@export var interaction: Interaction
@export var animation_player: AnimationPlayer


func enter() -> void:
	interaction.interacted.connect(_on_open_chest)
	animation_player.play("close")


func exit() -> void:
	interaction.interacted.disconnect(_on_open_chest)


func _on_open_chest() -> void:
	transitionned.emit(self, "Opening")
