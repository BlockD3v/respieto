extends Node

var inventory: Dictionary = {}

signal inventory_changed

func add_collectable(collectable_name: String) -> void:
	# Increment if exists, else set to 1
	if inventory.has(collectable_name):
		inventory[collectable_name] += 1
	else:
		inventory[collectable_name] = 1
	
	inventory_changed.emit()
