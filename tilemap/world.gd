extends Node2D

var fish = preload("res://fish/fish.tscn")
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var marker_2d = $Path2D/PathFollow2D/Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _on_spawn_timer_timeout():
	path_follow_2d.progress = randi_range(0, 1000)
	var instance = fish.instantiate()
	
	instance.global_position = marker_2d.global_position
	add_child(instance)
