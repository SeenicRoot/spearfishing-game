class_name Player
extends CharacterBody2D

signal max_breath_changed(max_value: float)
signal breath_changed(value: float)
signal surfaced
signal fishes_changed(captured_fishes: Array[Dictionary])

const SWIM_ANIMATION = &"swim"
const PANIC_ANIMATION = &"panic"

const MIN_ROTATE_SPEED = 25.0
const ROTATE_COOLDOWN = 0.25
const BREATH_LOSS_RATE = 1 # breath loss per second
const PANIC_SPEED = 500

@export var acceleration: float = 300.0
@export var deceleration: float = 100.0
@export var max_speed: float = 150.0
@export var max_breath: float = 100.0:
	set(val):
		max_breath = val
		max_breath_changed.emit(val)

var is_surfaced = true:
	set(val):
		if val and not is_surfaced:
			surfaced.emit()
		is_surfaced = val
var can_move: bool = true
var is_panicked: bool = false
var is_accelerating: bool = false
var harpoon_ready: bool = true
var flipped: bool = false
var can_rotate_sprite: bool = true

var breath: float = 100.0:
	set(val):
		breath = max(0, val)
		breath_changed.emit(breath)
var captured_fishes: Array[Dictionary] = []

@onready var sprite: Sprite2D = $Sprite2D
@onready var harpoon_launcher: HarpoonLauncher = $HarpoonLauncher
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fish_inventory: Node2D = $FishInventory
@onready var panic_timer: Timer = $PanicTimer


func _ready() -> void:
	animation_player.current_animation = "swim"
	breath = max_breath
	surfaced.connect(_on_surfaced)
	harpoon_launcher.captured_fish.connect(_on_captured_fish)
	panic_timer.timeout.connect(_on_panic_timer_timeout)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("accelerate"):
		is_accelerating = event.is_pressed()
	if event.is_action_pressed("shoot"):
		if harpoon_ready:
			shoot()


func _process(delta: float) -> void:
	calculate_breath(delta)


func _physics_process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var direction := (mouse_position - global_position).normalized()

	# decelerate
	velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)

	if not can_move:
		return

	if is_panicked:
		velocity = Vector2.UP * PANIC_SPEED
		rotate_player(Vector2.UP)
	# accelerate towards cursor
	elif is_accelerating and not is_panicked:
		if not animation_player.is_playing():
			animation_player.play()
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(max_speed)
		# face direction
		if can_rotate_sprite:
			rotate_player(direction)

	else:
		animation_player.pause()

	move_and_slide()

	# point harpoon_launcher at mouse position
	harpoon_launcher.global_rotation = direction.angle() 
	if abs(rad_to_deg(harpoon_launcher.rotation)) > 90 and not flipped:
		flip_player()
	elif abs(rad_to_deg(harpoon_launcher.rotation)) < 90 and flipped:
		flip_player()


func calculate_breath(delta: float) -> void:
	if is_surfaced:
		if breath < max_breath:
			const TIME_TO_RECOVER_FULL = 3
			var recovery_rate := max_breath / TIME_TO_RECOVER_FULL
			breath = min(breath + recovery_rate * delta, max_breath)
	else:
		breath -= BREATH_LOSS_RATE * delta

	if breath <= 0 and not is_panicked:
		start_panic()

func shoot() -> void:
	harpoon_launcher.shoot()


func start_panic() -> void:
	animation_player.stop()
	can_move = false
	is_panicked = true
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.RED, 1.5)
	await tween.finished
	
	animation_player.play(PANIC_ANIMATION)
	can_move = true
	panic_timer.start()


func drop_random_fish() -> void:
	if captured_fishes.size() == 0:
		return

	var random_fish := captured_fishes.pop_at(randi() % captured_fishes.size()) as Dictionary
	var temp_fish_node := Sprite2D.new()
	temp_fish_node.texture = random_fish.texture
	temp_fish_node.top_level = true
	add_child(temp_fish_node)

	const MIN_DROP_DISTANCE = 5
	const MAX_DROP_DISTANCE = 30
	var rand_distance := randf_range(MIN_DROP_DISTANCE, MAX_DROP_DISTANCE)
	var rand_direction := [Vector2.LEFT, Vector2.RIGHT].pick_random() as Vector2
	temp_fish_node.global_position = global_position + rand_direction * rand_distance
	temp_fish_node.rotate(randf_range(0, TAU))

	const FISH_DESPAWN_TIMER = 5
	get_tree().create_timer(FISH_DESPAWN_TIMER).timeout.connect(func () -> void: temp_fish_node.queue_free())
	fishes_changed.emit(captured_fishes)
	

func flip_player() -> void:
	harpoon_launcher.position.x = -harpoon_launcher.position.x
	harpoon_launcher.scale.y = -harpoon_launcher.scale.y
	sprite.flip_h = not sprite.flip_h
	flipped = not flipped


func rotate_player(direction: Vector2) -> void:
	if abs(direction.angle_to(Vector2.UP)) < deg_to_rad(45):
		rotation = deg_to_rad(0)
	elif abs(direction.angle_to(Vector2.DOWN)) < deg_to_rad(45):
		rotation = deg_to_rad(180)
	elif abs(direction.angle_to(Vector2.RIGHT)) < deg_to_rad(45):
		rotation = deg_to_rad(90)
	elif abs(direction.angle_to(Vector2.LEFT)) < deg_to_rad(45):
		rotation = deg_to_rad(270)
	can_rotate_sprite = false
	get_tree().create_timer(0.25).timeout.connect(func () -> void: can_rotate_sprite = true)


func _on_surfaced() -> void:
	if is_panicked:
		animation_player.current_animation = SWIM_ANIMATION
		modulate = Color.WHITE
		is_panicked = false
		panic_timer.stop()
	can_move = true

func _on_captured_fish(fishes: Array[Fish]) -> void:
	for fish in fishes:
		var fish_details := {
			"value": fish.point_value,
			"texture": fish.animated_sprite_2d.sprite_frames.get_frame_texture("default", 0),
		}
		captured_fishes.append(fish_details)
		fish.queue_free()
		fishes_changed.emit(captured_fishes)

	
func _on_panic_timer_timeout() -> void:
	if is_panicked:
		drop_random_fish()
