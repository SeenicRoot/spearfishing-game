extends Node

const CAMERA_SURFACE_OFFSET_Y = -75

@export var music: AudioStream

var game_running: bool = false
var is_surfaced: bool = true
var max_depth: float = 0

var total_points: int
var dive_points: int

@onready var game_ui: Control = %GameUI
@onready var world: Node2D = %World
@onready var world_camera: Camera2D = %World/Camera2D
@onready var player: CharacterBody2D = %World/Player
@onready var depth_meter: ProgressBar = %GameUI/%DepthMeter


func _ready() -> void:
	start_game()
	start_music()


func _process(_delta: float) -> void:
	if game_running:
		follow_camera_to_player()
		update_player_depth()


func show_surface() -> void:
	is_surfaced = true


func follow_camera_to_player() -> void:
	if not is_surfaced:
		world_camera.global_position = player.global_position
	else:
		world_camera.global_position.x = player.global_position.x
		world_camera.global_position.y = CAMERA_SURFACE_OFFSET_Y


func start_game() -> void:
	var surface_breakpoint := world.get_node("SurfaceBreakpoint") as Area2D
	surface_breakpoint.body_entered.connect(_on_surface_body_entered)
	surface_breakpoint.body_exited.connect(_on_surface_body_exited)
	
	player.harpoon_launcher.captured_fish.connect(_on_captured_fish)
	
	game_ui.visible = true
	game_running = true
	
	
func start_music() -> void:
	var music_player = AudioStreamPlayer.new()
	music_player.autoplay = true
	music_player.stream = music
	music_player.volume_db = -20
	add_child(music_player)


func update_player_depth() -> void:
	if player.position.y > max_depth:
		max_depth = player.position.y
		
	const GUI_MIN_DEPTH = 960
	if player.position.y > GUI_MIN_DEPTH:
		if not depth_meter.visible:
			depth_meter.modulate.a = 0
			depth_meter.visible = true
			var tween := get_tree().create_tween()
			tween.tween_property(depth_meter, "modulate:a", 1, 2)
	else:
		if depth_meter.visible:
			var tween := get_tree().create_tween()
			tween.tween_property(depth_meter, "modulate:a", 0, 2)
			await tween.finished
			depth_meter.visible = false
	
	
	depth_meter.value = player.position.y
	depth_meter.max_value = max_depth


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
