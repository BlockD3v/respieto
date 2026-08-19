class_name PlayerIndicatorComponent
extends Node2D

@export var player: Player
@export var tilemap_layer: TileMapLayer   # reference to your grass/tilled layer
@export var indicator_sprite: Sprite2D

var target_cell: Vector2i
var current_animation: String = "idle"

func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	if player == null or tilemap_layer == null:
		return

	# Get the target cell in front of the player
	var tile_size: Vector2 = tilemap_layer.tile_set.tile_size
	var target_world_pos: Vector2 = player.global_position + (player.player_direction * tile_size)
	target_cell = tilemap_layer.local_to_map(target_world_pos)
	var target_local_pos: Vector2 = tilemap_layer.map_to_local(target_cell)
	
	# Position the indicator
	global_position = target_local_pos
	
	# Update visibility and appearance based on tool
	update_indicator()

func update_indicator() -> void:
	if player.current_tool == DataTypes.Tools.None:
		hide()
		return

	show()
	
	match player.current_tool:
		DataTypes.Tools.TillGround:
			indicator_sprite.modulate = Color(0.6, 0.4, 0.2, 0.5)   # brown
		DataTypes.Tools.PlantCorn, DataTypes.Tools.PlantTomato:
			indicator_sprite.modulate = Color(0.2, 0.8, 0.2, 0.5)   # green
		DataTypes.Tools.AxeWood:
			indicator_sprite.modulate = Color(0.8, 0.2, 0.2, 0.5)   # red
			indicator_sprite.modulate = Color(1, 1, 1, 0.4)
