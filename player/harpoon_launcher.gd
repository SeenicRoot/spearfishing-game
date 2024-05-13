class_name HarpoonLauncher
extends Node2D

signal launched(harpoon: Area2D)

const DECELERATION = 10.0

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
var shooting: bool = false
var harpoon_velocity: float = 0
var harpoon_direction: Vector2 = Vector2.ZERO

@onready var loaded_sprite: Sprite2D = $LoadedSprite
@onready var unloaded_sprite: Sprite2D = $UnloadedSprite
@onready var harpoon: Area2D = $Harpoon


func _physics_process(delta: float) -> void:
	if shooting:
		move_harpoon(delta)


func shoot() -> void:
	if shooting:
		return
	unloaded_sprite.visible = true
	loaded_sprite.visible = false
	harpoon.visible = true
	shooting = true
	harpoon_velocity = harpoon_speed
	harpoon_direction = Vector2.from_angle(global_rotation)
	harpoon.global_rotation = global_rotation
	harpoon.global_position = global_position + harpoon_reset_position
	harpoon.get_node("Sprite2D").flip_v = scale.y < 0


func move_harpoon(delta: float) -> void:
	if harpoon_velocity > 0:
		harpoon.global_position += harpoon_direction * harpoon_velocity * delta
		harpoon_velocity -= DECELERATION
	else:
		# return the harpoon to the harpoon_speed launcher
		var reset_global_position := global_position + harpoon_reset_position
		var distance_squared := harpoon.position.distance_squared_to(reset_global_position)
		var velocity := reel_back_speed * delta
		var new_position := harpoon.position.move_toward(reset_global_position, velocity)
		harpoon.global_position = new_position
		if distance_squared < velocity ** 2:
			# reset launcher
			unloaded_sprite.visible = false
			loaded_sprite.visible = true
			harpoon.visible = false
			shooting = false
			harpoon_velocity = 0
			



func _on_projectile_hit() -> void:
	pass
