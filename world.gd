extends Node2D

const CHUNK_SIZE = Vector2i(1000, 1000)
const AVERAGE_SPAWN_RATE = 3

@export var fish_scenes: Array[PackedScene]

var created_chunks: Dictionary = {}
var current_chunk_rect: Rect2i

@onready var chunks: Node2D = $Chunks
@onready var fishes: Node2D = $Fishes


func get_chunk_rect(at: Vector2) -> Rect2i:
	# uses math to determine where the chunk is supposed to be
	var multiple := Vector2i(at) / CHUNK_SIZE
	var rect_pos := multiple * CHUNK_SIZE
	return Rect2i(rect_pos, CHUNK_SIZE)


func recreate_chunks(player_pos: Vector2) -> void:	
	var first_rect := get_chunk_rect(player_pos)
	create_chunk(first_rect)
	current_chunk_rect = first_rect
	
	for adjacent_rect in get_surrounding_chunk_rects(first_rect):
		if not adjacent_rect in created_chunks:
			create_chunk(adjacent_rect)
			spawn_fish(adjacent_rect)


func create_chunk(rect: Rect2i) -> Area2D:
	var area := Area2D.new()
	var collision_shape := CollisionShape2D.new()
	area.add_child(collision_shape)
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = CHUNK_SIZE
	area.global_position = rect.get_center()
	area.body_exited.connect(_on_chunk_body_exited)

	created_chunks[rect] = area
	chunks.add_child(area)
	return area

func spawn_fish(rect: Rect2i) -> void:
	var n_fish := int(randf() * AVERAGE_SPAWN_RATE * 2)
	for i in range(n_fish):
		var rand_x := randi_range(rect.position.x, rect.end.x)
		var rand_y := randi_range(rect.position.y, rect.end.y)
		var new_fish := fish_scenes.pick_random().instantiate() as Fish
		new_fish.global_position = Vector2(rand_x, rand_y)

		fishes.add_child(new_fish)


func clear_chunks() -> void:
	for chunk: Area2D in created_chunks.values():
		chunk.queue_free()
	for fish in fishes.get_children():
		fish.queue_free()
	created_chunks = {}


func get_surrounding_chunk_rects(chunk_rect: Rect2i) -> Array[Rect2i]:
	var surrounding_rects: Array[Rect2i] = []

	for offset_x in [-CHUNK_SIZE.x, 0, CHUNK_SIZE.x]:
		for offset_y in [-CHUNK_SIZE.y, 0, CHUNK_SIZE.y]:
			if offset_x == 0 and offset_y == 0:
				continue
			var new_rect := chunk_rect
			new_rect.position.x += offset_x
			new_rect.position.y += offset_y
			# don't make chunks in the sky
			if new_rect.position.y < 0:
				continue
			
			surrounding_rects.append(new_rect)
	return surrounding_rects


func _on_chunk_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	current_chunk_rect = get_chunk_rect(body.global_position)
	var surrounding_chunk_rects := get_surrounding_chunk_rects(current_chunk_rect)
	for rect in surrounding_chunk_rects:
		if not rect in created_chunks:
			create_chunk.call_deferred(rect)
			spawn_fish.call_deferred(rect)

