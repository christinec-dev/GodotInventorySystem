### Inventory_Item.gd
@tool
extends Node2D

# Item details for editor window
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
var scene_path: String = "res://Scenes/Inventory_Item.tscn"

# Scene-Tree Node references
@onready var icon_sprite = $Sprite2D

# Variables
var player_in_range = false

func _ready():
	# Set the texture to reflect in the game
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func _process(_delta):
	# Set the texture to reflect in the editor
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
	# Add item to inventory if player presses "E" within range
	if player_in_range and Input.is_action_just_pressed("ui_add"):
		pickup_item()

# Add item to inventory
func pickup_item():
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"effect": item_effect,
		"texture": item_texture,
		"scene_path": scene_path
	}
	if Global.player_node:
		Global.add_item(item, false)
		self.queue_free()

# If player is in range, show UI and make item pickable
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		body.interact_ui.visible = true
		
# If player is in range, hide UI and don't make item pickable
func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		body.interact_ui.visible = false
		
# Set the items values for spawning
func initiate_items(type, name, effect, texture):
	item_type = type
	item_name = name
	item_effect = effect
	item_texture = texture
	
# Sets the item's dictionary data
func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]
