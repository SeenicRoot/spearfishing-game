extends Node

@export var world_scene: PackedScene
@export var player_scene: PackedScene

var game_running: bool = false
var world: Node2D
var world_camera: Camera2D
var player: CharacterBody2D


func _ready() -> void:
	for child in get_children():
		queue_free()
	world = world_scene.instantiate()
	world_camera = world.get_node("Camera2D") as Camera2D
	add_child(world)
	player = player_scene.instantiate() as CharacterBody2D
	world.add_child(player)
	player.item_rect_changed.connect(_on_player_rect_changed)
	game_running = true


func _process(_delta: float) -> void:
	if game_running:
		world_camera.global_position = player.global_position
	

func _on_player_rect_changed() -> void:
	world.get_node("Camera2D").global_position = player.global_position
