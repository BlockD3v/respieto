extends Node2D

var corn_harvest_scene = preload("res://scenes/objects/tomato.tscn")
var tomato_harvest_scene = preload("res://scenes/objects/corn.tscn")

@export var dialogue_start_command: String
@export var food_drop_height: int = 40
@export var reward_output_radius: int = 20
@export var output_reward_scenes: Array[PackedScene] = []

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var feed_component: FeedComponent = $FeedComponent
@onready var reward_marker: Marker2D = $RewardMarker

var in_range: bool
var is_chest_open: bool = false

func _ready() -> void:
	animated_sprite_2d.play("chest_close")
	
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)

func on_interactable_activated() -> void:
	in_range = true
	give_rewards()

func on_interactable_deactivated() -> void:
	in_range = false
	animated_sprite_2d.play("chest_close")

func give_rewards() -> void:
	if is_chest_open:
		return

	animated_sprite_2d.play("chest_open")
	
	for reward_scene in output_reward_scenes:
		var reward_instance = reward_scene.instantiate() as Node2D
		if reward_instance:
			var angle = randf() * TAU
			var distance = randf_range(0, reward_output_radius)
			reward_instance.global_position = reward_marker.global_position + Vector2(cos(angle), sin(angle)) * distance
			get_parent().add_child(reward_instance)

	is_chest_open = true
