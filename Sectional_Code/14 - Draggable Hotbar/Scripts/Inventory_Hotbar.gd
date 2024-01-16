### Inventory_Hotbar.gd

extends Control

@onready var hotbar_container = $HBoxContainer

# Drag/Drop
var dragged_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()

# Create the hotbar slots
func _update_hotbar_ui():
	clear_hotbar_container()
	for i in range(Global.hotbar_size):
		var slot =  Global.inventory_slot_scene.instantiate()
		slot.set_slot_index(i)
		
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		hotbar_container.add_child(slot)
		if Global.hotbar_inventory[i] != null:
			slot.set_item(Global.hotbar_inventory[i])
		else:
			slot.set_empty()
		slot.update_assignment_status()
		
# Clear hotbar slots
func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child  = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()

# Store dragged slot reference
func _on_drag_start(slot_control : Control):
	dragged_slot = slot_control
	print("Drag started fro slot: ", dragged_slot)
	
func _on_drag_end():
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null	
	
# Get the current mouse position in the hotbar_container's coordinate system
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in hotbar_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null
	
# Find the index of a slot	
func get_slot_index(slot: Control) -> int:
	for i in range(hotbar_container.get_child_count()):
		if hotbar_container.get_child(i) == slot:
			# Valid slot found
			return i
	# Invalid slot
	return -1
	
# Drop slots
func drop_slot(slot1: Control, slot2: Control):
	var slot1_index = get_slot_index(slot1)	
	var slot2_index = get_slot_index(slot2)	
	if slot1_index == -1 or slot2_index == -1:
		print("Invalid slots found")
		return
	else:
		if Global.swap_hotbar_items(slot1_index, slot2_index):
			print("Drpping slot items: ", slot1, slot2_index)
			_update_hotbar_ui()
		
