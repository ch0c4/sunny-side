extends Node

const AXE = preload("uid://dl1rpw2ppwnfj")
const SWORD = preload("uid://43221pfbt5ki")
const PICKAXE = preload("uid://cseat50es5phx")


var inventory: Inventory = Inventory.new().set_size(15)

var tools_inventory: Inventory = (Inventory.new().set_size(15)
									.add_item(SWORD, 1)
									.add_item(PICKAXE, 1))

var action_inventory: Inventory = (Inventory.new()
									  .set_size(4)
									  .add_item(AXE, 1))
