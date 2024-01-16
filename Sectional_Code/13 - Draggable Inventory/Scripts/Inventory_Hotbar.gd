### Inventory_Hotbar.gd

extends Control

# Scene-Tree Node references
@onready var hotbar_container = $HBoxContainer

func _ready():
	Global.inventory_updated.connect(_update_hotbar)
	_update_hotbar()

# Create the hotbar slots
func _update_hotbar():
	clear_hotbar_container()
	for i in range(Global.hotbar_size):
		var slot = Global.inventory_slot_scene.instantiate()
		slot.set_slot_index(i)
		hotbar_container.add_child(slot)
		if Global.hotbar_inventory[i] != null:
			slot.set_item(Global.hotbar_inventory[i])
		else:
			slot.set_empty()
		slot.update_assignment_status()

		
# Clear hotbar slots
func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()
