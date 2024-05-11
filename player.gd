class_name Player
extends CharacterBody2D

@export var acceleration: float = 300.0
@export var deceleration: float = 100.0
@export var max_velocity: float = 150.0

var is_accelerating: bool = false
var mouse_position: Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		mouse_position = event.global_position
	if event.is_action("accelerate"):
		is_accelerating = event.is_pressed()

func _physics_process(delta: float) -> void:
	# decelerate
	velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)

	# accelerate towards cursor
	if is_accelerating:
		var direction := (mouse_position - global_position).normalized()
		velocity += direction * acceleration * delta
		velocity = velocity.limit_length(max_velocity)
	move_and_slide()

