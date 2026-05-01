extends Node

@warning_ignore_start("unused_signal")

signal request_camera_target(new_target: RemoteTransform2D)
signal request_description(title: String, description: String)
signal action_selected(index: int, item_box: ItemBox)
signal transition_entered(transition: Transition)

@warning_ignore_restore("unused_signal")
