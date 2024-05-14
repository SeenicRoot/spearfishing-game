extends TileMap

const BUBBLE_FREQUENCY: int = 10

var bubbles = [
	Vector2i(7, 7),
	Vector2i(9, 7),
]

var map: Array[Vector2i] = get_used_cells(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(BUBBLE_FREQUENCY):
		set_cell(0, map.pick_random(), 0, bubbles.pick_random(), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
