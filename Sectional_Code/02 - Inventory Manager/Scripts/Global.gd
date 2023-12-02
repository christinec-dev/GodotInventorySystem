### Global.gd

extends Node

# Scene and node references
var player_node: Node = null

# Inventory items
var inventory = []

# Custom signals
signal inventory_updated

func _ready(): 
	# Initializes the inventory with 30 slots (spread over 9 blocks per row)
	inventory.resize(30) 
	
# Sets the player reference for inventory interactions
func set_player_reference(player):
	player_node = player
	
# Adds an item to the inventory, returns true if successful
func add_item():
	inventory_updated.emit()
	

# Removes an item from the inventory based on type and effect
func remove_item():
	inventory_updated.emit()

# Increase inventory size dynamically
func increase_inventory_size():
	inventory_updated.emit()
