extends NonPlayableCharacter

@export var egg_scene: PackedScene = preload("res://scenes/objects/egg.tscn")
@export var egg_spawn_offset: Vector2 = Vector2(0, -15)

var egg_produced_today: bool = false

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	
	if DayAndNightCycleManager:
		DayAndNightCycleManager.time_tick_day.connect(_on_new_day)
	else:
		#print("⚠️ DayAndNightCycleManager not found – egg production disabled.")
		return
func _on_new_day(_day: int) -> void:
	egg_produced_today = false
	lay_egg()

func lay_egg() -> void:
	if egg_produced_today:
		return

	if egg_scene == null:
		#print("⚠️ egg_scene not set in chicken.gd")
		return

	var egg_instance = egg_scene.instantiate()
	egg_instance.global_position = global_position + egg_spawn_offset
	get_parent().add_child(egg_instance)

	egg_produced_today = true
