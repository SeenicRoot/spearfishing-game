class_name HarpoonLauncher
extends Node2D

signal launched(harpoon: Area2D)
signal captured_fish(fishes: Array[Fish])

const DECELERATION_FACTOR = 0.9
const DECELERATION_FORCE = 100

@export var harpoon_speed: float = 500
@export var reel_back_speed: float = 200
@export var harpoon_reset_position: Vector2 = Vector2.ZERO

var flip_h: bool = false:
	set(val):
		loaded_sprite.flip_h = val
		unloaded_sprite.flip_h = val
		harpoon_reset_position.x = -harpoon.position.x
		flip_h = val
var flip_v: bool = false:
	set(val):
		loaded_sprite.flip_v = val
		unloaded_sprite.flip_v = val
		harpoon_reset_position.y = -harpoon.position.y
		flip_v = val

var loaded: bool = true
var reeling_harpoon: bool = false
var harpoon_velocity: float = 0
var harpoon_direction: Vector2 = Vector2.ZERO
var hooked_fishes: Array[Fish] = []

@onready var loaded_sprite: Sprite2D = $LoadedSprite
@onready var unloaded_sprite: Sprite2D = $UnloadedSprite
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var harpoon: Area2D = $Harpoon
@onready var harpoon_particles: GPUParticles2D = $Harpoon/GPUParticles2D
@onready var harpoon_sprite: Sprite2D = $Harpoon/Sprite2D


func _ready() -> void:
	harpoon_particles.emitting = false
	harpoon_sprite.visible = false


func _physics_process(delta: float) -> void:
	if not loaded and not reeling_harpoon:
		move_harpoon(delta)
	elif not loaded and reeling_harpoon:
		reel_harpoon(delta)


func shoot() -> void:
	if not loaded:
		return
	unloaded_sprite.visible = true
	loaded_sprite.visible = false
	harpoon_sprite.visible = true
	loaded = false
	harpoon_velocity = harpoon_speed
	harpoon.global_rotation = global_rotation
	harpoon.global_position = global_position + harpoon_reset_position
	harpoon_direction = (get_global_mouse_position() - harpoon.global_position).normalized()
	harpoon.get_node("Sprite2D").flip_v = scale.y < 0
	audio_player.play()
	harpoon_particles.restart()
	harpoon_particles.emitting = true


func move_harpoon(delta: float) -> void:
	if harpoon_velocity > 0:
		harpoon.global_position += harpoon_direction * harpoon_velocity * delta
		harpoon_velocity -= (DECELERATION_FORCE + harpoon_velocity * DECELERATION_FACTOR) * delta
	else:
		# return the harpoon to the harpoon_speed launcher
		reeling_harpoon = true


func reel_harpoon(delta: float) -> void:
	var reset_global_position := global_position + harpoon_reset_position
	var distance_squared := harpoon.position.distance_squared_to(reset_global_position)
	var velocity := reel_back_speed * delta
	var new_position := harpoon.position.move_toward(reset_global_position, velocity)
	harpoon.global_position = new_position
	harpoon_particles.emitting = false

	if distance_squared < velocity ** 2:
		# reset harpoon once it reaches the player
		reeling_harpoon = false
		unloaded_sprite.visible = false
		loaded_sprite.visible = true
		harpoon_sprite.visible = false
		loaded = true
		harpoon_velocity = 0
		captured_fish.emit(hooked_fishes)
		hooked_fishes = []


func _on_harpoon_body_entered(body: Node2D) -> void:
	if reeling_harpoon: # do not catch fish if harpoon is returning
		return
	if body is Fish and body.process_mode != PROCESS_MODE_DISABLED:
		body.process_mode = PROCESS_MODE_DISABLED
		body.reparent(harpoon)
		hooked_fishes.append(body)
