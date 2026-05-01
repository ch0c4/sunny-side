class_name ChessOpenState extends State

@export var animation_player: AnimationPlayer

@onready var chest: Chest = get_owner()
@onready var player: Player = MainInstance.player


func enter() -> void:
	animation_player.play("open")
	
	if chest.item is not Item:
		return
		
	player.collect_item(chest.item, chest.amount)
