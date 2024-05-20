extends Node

const World = preload("res://world.gd")

const CAMERA_SURFACE_OFFSET_Y = -75

var game_running: bool = false
var show_surface: bool = true
var max_depth: float = 0.0

var total_points: int
var high_score: int:
	set(val):
		high_score_label.text = "Highscore: " + str(val)
		high_score = val
var dive_points: int = 0
var camera_follow_player: bool = true
var camera_offset_y: float = 0.0

@onready var game_ui: Control = %GameUI
@onready var world: World = %World
@onready var world_camera: Camera2D = %World/Camera2D
@onready var player: Player = %World/Player
@onready var music_player: AudioStreamPlayer = $MusicPlayer

@onready var depth_meter: ProgressBar = %GameUI/%DepthMeter
@onready var breath_meter: ProgressBar = %GameUI/%BreathMeter
@onready var dive_points_label: Label = %GameUI/Score
@onready var high_score_label: Label = %GameUI/Highscore
@onready var shop_ui: Control = $ShopUI


func _ready() -> void:
	start_game()


func _process(_delta: float) -> void:
	if game_running:
		follow_player()
		update_player_depth()


func follow_player() -> void:
	world_camera.global_position.x = player.global_position.x
	if not player.is_surfaced:
		world_camera.global_position.y = player.global_position.y + camera_offset_y
	else:
		camera_offset_y = CAMERA_SURFACE_OFFSET_Y - player.global_position.y

	shop_ui.global_position.x = player.global_position.x - shop_ui.size.x / 2
	

func change_camera_view() -> void:
	if player.is_surfaced:
		var tween := create_tween()
		tween.tween_property(world_camera, "position:y", CAMERA_SURFACE_OFFSET_Y, 1)
	else:
		var tween := create_tween()
		tween.tween_property(self, "camera_offset_y", 0.0, 1)
		

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
		player.surfaced.emit()
		show_surface = true
		if dive_points > high_score:
			high_score = dive_points
		total_points += dive_points
		dive_points = 0
		high_score_label.visible = true
		max_depth = 0
		change_camera_view()
		player.captured_fishes = []
		world.clear_chunks()
	else:
		body.queue_free()


func _on_surface_body_exited(body: Node2D) -> void:
	if body is Player:
		player.dived.emit()
		show_surface = false
		change_camera_view()
		dive_points_label.text = str(dive_points) + "pts"
		high_score_label.visible = false
		
		randomize()

		world.recreate_chunks.call_deferred(player.global_position)


func _on_fishes_changed(captured_fishes: Array[Dictionary]) -> void:
	dive_points = captured_fishes.reduce(func (accum, fish): return accum + fish.value, 0)
	dive_points_label.text = str(dive_points) + "pts"
	
	
func _on_music_player_finished() -> void:
	music_player.play()
