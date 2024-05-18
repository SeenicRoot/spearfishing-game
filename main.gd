extends Node

signal player_upgraded(player: Player)

const CAMERA_SURFACE_OFFSET_Y = -75
const SURFACE_THRESHOLD = 5

@export var music: AudioStream

var game_running: bool = false
var show_surface: bool = true
var max_depth: float = 0.0

var total_points: int
var dive_points: int:
	set(val):
		dive_points = val
		dive_points_display.text = "Points: " + str(dive_points)
var camera_follow_player: bool = true
var camera_offset_y: float = 0.0

@onready var game_ui: Control = %GameUI
@onready var world: Node2D = %World
@onready var world_camera: Camera2D = %World/Camera2D
@onready var player: Player = %World/Player
@onready var depth_meter: ProgressBar = %GameUI/%DepthMeter
@onready var breath_meter: ProgressBar = %GameUI/%BreathMeter
@onready var dive_points_display: Label = %GameUI/Score


func _ready() -> void:
	start_game()
	start_music()


func _process(_delta: float) -> void:
	if game_running:
		follow_camera_to_player()
		update_player_depth()


func follow_camera_to_player() -> void:
	world_camera.global_position.x = player.global_position.x
	if not player.is_surfaced:
		world_camera.global_position.y = player.global_position.y + camera_offset_y
	
func change_camera_view() -> void:
	if player.is_surfaced:
		var tween := create_tween()
		tween.tween_property(world_camera, "position:y", CAMERA_SURFACE_OFFSET_Y, 1)
	else:
		var y_distance := world_camera.global_position.y - player.global_position.y
		var tween := create_tween()
		tween.tween_property(self, "camera_offset_y", 0.0, 1).from(y_distance)
		

func start_game() -> void:
	var surface_breakpoint := world.get_node("SurfaceBreakpoint") as Area2D
	surface_breakpoint.body_entered.connect(_on_surface_body_entered)
	surface_breakpoint.body_exited.connect(_on_surface_body_exited)
	
	player.breath_changed.connect(func (val: float) -> void: breath_meter.value = val)
	breath_meter.value = player.breath
	player.max_breath_changed.connect(func (val: float) -> void: breath_meter.max_value = val)
	breath_meter.max_value = player.max_breath
	player.fishes_changed.connect(_on_fishes_changed)
	
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
			var tween := create_tween()
			tween.tween_property(depth_meter, "modulate:a", 1, 2)
	else:
		if depth_meter.visible:
			var tween := create_tween()
			tween.tween_property(depth_meter, "modulate:a", 0, 2)
			await tween.finished
			depth_meter.visible = false
	
	
	depth_meter.value = player.position.y
	depth_meter.max_value = max_depth


func _on_surface_body_entered(body: Node2D) -> void:
	if body is Player:
		player.is_surfaced = true
		show_surface = true
		total_points += dive_points
		dive_points = 0
		max_depth = 0
		change_camera_view()
		player.captured_fishes = []
	else:
		body.queue_free()


func _on_surface_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player.is_surfaced = false
		show_surface = false
		change_camera_view()

func _on_fishes_changed(captured_fishes: Array[Dictionary]) -> void:
	dive_points = captured_fishes.reduce(func (accum, fish): return accum + fish.value, 0)
