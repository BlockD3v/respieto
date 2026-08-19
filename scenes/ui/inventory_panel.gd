extends PanelContainer

@onready var log_label: Label = $MarginContainer/VBoxContainer/Logs/TextureRect/LogLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomato/TextureRect/TomatoLabel
@onready var corn_label: Label = $MarginContainer/VBoxContainer/Corn/TextureRect/CornLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/TextureRect/StoneLabel
@onready var milk_label: Label = $MarginContainer/VBoxContainer/Milk/TextureRect/MilkLabel
@onready var egg_label: Label = $MarginContainer/VBoxContainer/Egg/TextureRect/EggLabel   # <-- added

func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	on_inventory_changed()

func on_inventory_changed() -> void:
	var inventory: Dictionary = InventoryManager.inventory

	if inventory.has("log"):
		log_label.text = str(inventory["log"])
	else:
		log_label.text = "0"

	if inventory.has("stone"):
		stone_label.text = str(inventory["stone"])
	else:
		stone_label.text = "0"

	if inventory.has("CornHarvest"):
		corn_label.text = str(inventory["CornHarvest"])
	else:
		corn_label.text = "0"

	if inventory.has("TomatoHarvest"):
		tomato_label.text = str(inventory["TomatoHarvest"])
	else:
		tomato_label.text = "0"

	if inventory.has("milk"):
		milk_label.text = str(inventory["milk"])
	else:
		milk_label.text = "0"

	if inventory.has("egg"):
		egg_label.text = str(inventory["egg"])
	else:
		egg_label.text = "0"
