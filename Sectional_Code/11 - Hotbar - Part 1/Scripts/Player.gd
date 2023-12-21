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
	