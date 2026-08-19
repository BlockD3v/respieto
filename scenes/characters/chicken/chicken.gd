extends NonPlayableCharacter

@export var milk_scene: PackedScene = preload("res://scenes/objects/milk.tscn")
@export var milk_spawn_offset: Vector2 = Vector2(0, -20)   # lift above ground

var milk_produced_today: bool = false

func _ready() -> void:
	# Your existing walk_cycles setup
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	
	# Connect to day change signal
	if DayAndNightCycleManager:
		DayAndNightCycleManager.time_tick_day.connect(_on_new_day)
	else:
		return

func _on_new_day(_day: int) -> void:
	milk_produced_today = false   # reset flag for new day
	produce_milk()

func produce_milk() -> void:
	if milk_produced_today:
		return   # already milked today

	if milk_scene == null:
		#print("⚠️ milk_scene not set in cow.gd")
		return

	var milk_instance = milk_scene.instantiate()
	milk_instance.global_position = global_position + milk_spawn_offset
	get_parent().add_child(milk_instance)

	milk_produced_today = true
