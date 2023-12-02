###Inventory_UI.gd
extends Control

# Scene-Tree Node references
@onready var grid_container = $GridContainer

func _ready():
	# Connect function to signal to update inventory UI
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

# Update inventory U
func _on_inventory_updated():  
	# Clear existing slots
	clear_grid_container()

# Clear inventory UI grid
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
