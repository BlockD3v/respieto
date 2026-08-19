class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer
@export var grass_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 1
@export var player: Player
@export var crop_container: Node2D

var corn_plant_scene = preload("res://scenes/objects/plants/corn.tscn")
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float
var target_cell: Vector2i

func _ready() -> void:
	if crop_container == null:
		crop_container = get_tree().current_scene.find_child("CropFields", true, false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_target_cell()
			remove_crop()
	
	if event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_target_cell()
			if check_tilled_soil():
				add_crop()
				#remove_tilled_soil()

func get_target_cell() -> void:
	var tile_size: Vector2 = tilled_soil_tilemap_layer.tile_set.tile_size
	var target_world_pos: Vector2 = player.global_position + (player.player_direction * tile_size)
	target_cell = tilled_soil_tilemap_layer.local_to_map(target_world_pos)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(target_cell)
	distance = player.global_position.distance_to(local_cell_position)

func check_tilled_soil() -> bool:
	if distance < 30.0:
		var source_id = tilled_soil_tilemap_layer.get_cell_source_id(target_cell)
		return source_id != -1
	return false

func remove_tilled_soil() -> void:
	tilled_soil_tilemap_layer.erase_cell(target_cell)

func add_crop() -> void:
	if crop_container == null:
		return
	if distance < 30.0:
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
			var corn_instance = corn_plant_scene.instantiate() as Node2D
			corn_instance.global_position = local_cell_position
			crop_container.add_child(corn_instance)

		if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			var tomato_instance = tomato_plant_scene.instantiate() as Node2D
			tomato_instance.global_position = local_cell_position
			crop_container.add_child(tomato_instance)

func remove_crop() -> void:
	if crop_container == null:
		return
	if distance < 30.0:
		var crop_nodes = crop_container.get_children()
		for node in crop_nodes:
			if node is Node2D and node.global_position == local_cell_position:
				node.queue_free()
