extends ProgressBar

const PIXELS_PER_METER = 32

@onready var max_depth_label: Label = $MaxDepth
@onready var meter: Control = %Meter
@onready var player_marker: ColorRect = %PlayerDepthMarker


func _ready() -> void:
	update_max_depth()
	move_marker()


func update_max_depth() -> void:
	var depth_in_meters := max_value / PIXELS_PER_METER
	max_depth_label.text = "%.3fm" % depth_in_meters


func move_marker() -> void:
	player_marker.position.y = ratio * meter.size.y


func _on_changed() -> void:
	update_max_depth()
	move_marker()

	
func _on_value_changed(_value: float) -> void:
	move_marker()
