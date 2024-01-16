### Inventory_Slot.gd

extends Control

# Scene-Tree Node references
@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/AssignButton
@onready var outer_border = $OuterBorder

# Signals
signal drag_start(slot)
signal drag_end()

# Slot item
var item = null
var slot_index = -1
var is_assigned = false

# Set index
func set_slot_index(new_index):
	slot_index = new_index

# Show item details on hover enter
func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true

# Hide item details on hover exit
func _on_item_button_mouse_exited():
	details_panel.visible = false

# Default empty slot
func set_empty():
	icon.texture = null
	quantity_label.text = ""

# Set slot item with its values from the dictionary
func set_item(new_item):
	item = new_item
	icon.texture = item["texture"] 
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ ", item["effect"])
	else: 
		item_effect.text = ""
	update_assignment_status()

# Remove item from inventory and drop it back into the world        		
func _on_drop_button_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 50)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["effect"])
		Global.remove_hotbar_item(item["type"], item["effect"])
		usage_panel.visible = false

# Remove item from inventory, use it, and apply its effect (if possible)		
func _on_use_button_pressed():
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if Global.player_node:
			Global.player_node.apply_item_effect(item)
			Global.remove_item(item["type"], item["effect"])
			Global.remove_hotbar_item(item["type"], item["effect"])
		else:
			print("Player could not be found")

# Updates hotbar assignment status
func update_assignment_status():
	is_assigned = Global.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_button.text = "Unassign"
	else:
		assign_button.text = "Assign"
		
# Assigns/Unassigns hotbar item
func _on_assign_button_pressed():
	if item != null:
		if is_assigned:
			Global.unassign_hotbar_item(item["type"], item["effect"])
			is_assigned = false
		else:
			Global.add_item(item, true)
			is_assigned = true
		update_assignment_status()
		
# ItemButtons pressed events
func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		# Usage panel
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if item != null:
				usage_panel.visible = !usage_panel.visible
		# Dragging item
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()
				
				
		
		
