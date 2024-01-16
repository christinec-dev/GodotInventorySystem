### Player.gd
extends CharacterBody2D

# Scene-Tree Node references
@onready var inventory_ui = $InventoryUI
@onready var interact_ui = $InteractUI
@onready var animated_sprite = $AnimatedSprite 
@onready var hotbar_ui = $InventoryHotbar

# Variables
@export var speed = 200

func _ready():
	# Set this node as the Player node
	Global.set_player_reference(self)

# Input for movement
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

# Movement & Animation
func _physics_process(delta):
	get_input()
	move_and_slide()
	update_animation()

# Animation
func update_animation():
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite.play("walk_right")
			else:
				animated_sprite.play("walk_left")
		else:
			if velocity.y > 0:
				animated_sprite.play("walk_down")  
			else:
				animated_sprite.play("walk_up")

# Show inventory menu on "I" pressed
func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
		hotbar_ui.visible = !hotbar_ui.visible
		
# Apply the effect of the item (if possible)
func apply_item_effect(item):
	match item["effect"]:
		"Stamina":
			speed += 50
			print("Speed increased to ", speed)
		"Slot Boost":
			Global.increase_inventory_size(5)
			print("Inventory increased to ", Global.inventory.size())
		_:
			print("No effect for this item")
	
# Use hotbar items on key 1 - 5 press		
func use_hotbar_item(slot_index):
	if slot_index < Global.hotbar_inventory.size():
		var item = Global.hotbar_inventory[slot_index]
		if item != null:
			# Use item
			apply_item_effect(item)
			# Remove item
			item["quantity"] -= 1
			if item["quantity"] <= 0:
				Global.hotbar_inventory[slot_index] = null
				Global.remove_item(item["type"], item["effect"])
			Global.inventory_updated.emit()  

# Hotbar shortcuts
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		# Then check for specific keys
		for i in range(Global.hotbar_size):
			# Assuming keys 1-5 are mapped to actions "hotbar_1" to "hotbar_5" in the Input Map
			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
				use_hotbar_item(i)
				break


