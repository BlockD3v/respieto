extends Node

var main_scene_path: String = "res://scenes/main_scene.tscn"
var main_scene_level_root_path: String = "LevelMain/Lvl1"

var level_scenes: Dictionary = {
	"Level1": "res://scenes/lvl/lvl_1.tscn"
}

var main_scene_root: Node

func load_main_scene_container() -> void:
	var node: Node = load(main_scene_path).instantiate()
	if node != null:
		get_tree().root.add_child(node)
		get_tree().current_scene = node
		main_scene_root = node
		print("✅ Main scene loaded. Root name: ", node.name)

func load_level(level: String) -> void:
	var scene_path: String = level_scenes.get(level)
	if scene_path == null:
		return
	
	var level_scene: Node = load(scene_path).instantiate()
	
	if main_scene_root == null:
		push_error("❌ Main scene root is null! Call load_main_scene_container() first.")
		return
	
	var level_root: Node = main_scene_root.get_node(main_scene_level_root_path)
	if level_root == null:
		level_root = main_scene_root.find_child("Lvl1", true, false)
		if level_root == null:
			push_error("❌ Could not find level container node.")
			return
	
	# Clear existing children
	for child in level_root.get_children():
		child.queue_free()
	
	# Defer adding the level to ensure main scene is ready
	call_deferred("_add_level_deferred", level_root, level_scene)
	print("✅ Level loaded: ", level)

func _add_level_deferred(level_root: Node, level_scene: Node) -> void:
	level_root.add_child(level_scene)
	print("✅ Level scene added to: ", level_root.name)
	# Force visibility just in case
	level_scene.visible = true
	print("🔍 Level scene children count: ", level_scene.get_child_count())
