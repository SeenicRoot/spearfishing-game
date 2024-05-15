extends Node

const CAMERA_SURFACE_OFFSET_Y = -75

@export var world_scene: PackedScene
@export var player_scene: PackedScene
@export var music: AudioStream

var game_running: bool = false
var world: Node2D
var world_camera: Camera2D
var player: CharacterBody2D
var is_surfaced: bool = true
var display_dive_points: Label

var total_points: int
var dive_points: int

func _ready() -> void:
	for child in get_children():
		queue_free()
	start_game()
	start_music()


func _process(_delta: float) -> void:
	if game_running:
		follow_camera_to_player()


func show_surface() -> void:
	is_surfaced = true


func follow_camera_to_player() -> void:
	if not is_surfaced:
		world_camera.global_position = player.global_position
	else:
		world_camera.global_position.x = player.global_position.x
		world_camera.global_position.y = CAMERA_SURFACE_OFFSET_Y


func start_game() -> void:
	world = world_scene.instantiate()
	world_camera = world.get_node("Camera2D") as Camera2D
	var surface_breakpoint := world.get_node("SurfaceBreakpoint") as Area2D
	surface_breakpoint.body_entered.connect(_on_surface_body_entered)
	surface_breakpoint.body_exited.connect(_on_surface_body_exited)
	add_child(world)
	
	player = player_scene.instantiate() as CharacterBody2D
	world.add_child(player)
	player.harpoon_launcher.captured_fish.connect(_on_captured_fish)
	
	game_running = true
	
	
func start_music() -> void:
	var music_player = AudioStreamPlayer.new()
	music_player.autoplay = true
	music_player.stream = music
	music_player.volume_db = -20
	add_child(music_player)

func _on_surface_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_surfaced = true
		total_points += dive_points
		dive_points = 0

	else:
		body.queue_free()


func _on_surface_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_surfaced = false

func _on_captured_fish(fish: Fish) -> void:
	fish.queue_free()
	dive_points += fish.point_value
	display_dive_points = world.get_node("Camera2D/CanvasLayer/Score") as Label
	display_dive_points.set_text("Points: " + str(dive_points))
	
	
