class_name PlayerDoingState extends State

@export var animation_player: AnimationPlayer
@export var interaction_detector: InteractionDetector

@onready var player: Player = get_owner()

func enter() -> void:
	player.in_action.emit(true)
	animation_player.animation_finished.connect(_on_doing_finished)
	animation_player.play("doing")
	interaction_detector.get_current_interaction().run()


func exit() -> void:
	if animation_player.animation_finished.is_connected(_on_doing_finished):
		animation_player.animation_finished.disconnect(_on_doing_finished)
		
	player.in_action.emit(false)


func _on_doing_finished(_anim_name: StringName) -> void:
	transitionned.emit(self, "Idle")
