class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 1
@export var player: Player

var target_cell: Vector2i
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_target_cell()
			remove_tilled_soil_cell()
	
	if event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_target_cell()
			add_tilled_soil_cell()

func get_target_cell() -> void:
	var tile_size: Vector2 = grass_tilemap_layer.tile_set.tile_size
	var target_world_pos: Vector2 = player.global_position + (player.player_direction * tile_size)
	target_cell = grass_tilemap_layer.local_to_map(target_world_pos)
	distance = player.global_position.distance_to(grass_tilemap_layer.map_to_local(target_cell))

func add_tilled_soil_cell() -> void:
	if distance < 30.0:
		var source_id = grass_tilemap_layer.get_cell_source_id(target_cell)
		if source_id != -1:
			tilled_soil_tilemap_layer.set_cells_terrain_connect([target_cell], terrain_set, terrain, true)

func remove_tilled_soil_cell() -> void:
	if distance < 30.0:
		var tilled_source = tilled_soil_tilemap_layer.get_cell_source_id(target_cell)
		if tilled_source != -1:
			tilled_soil_tilemap_layer.erase_cell(target_cell)
