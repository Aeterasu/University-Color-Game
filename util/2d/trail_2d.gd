class_name Trail2D extends Line2D

@export_category("Trail")
@export var length: int = 10
@export var fps: float = 60.0 # custom FPS for this script

@onready var parent: Node2D = get_parent()
var offset: Vector2 = Vector2.ZERO

@export var enabled: bool = true:
	set(value):
		enabled = value
		reset()
	get:
		return enabled

var _time_accum: float = 0.0
var _step: float = 1.0 / 60.0 # will be recalculated when fps changes

func _ready() -> void:
	offset = position
	top_level = true
	_step = 1.0 / fps

func _physics_process(delta: float) -> void:
	if not enabled:
		return

	_time_accum += delta
	while _time_accum >= _step:
		_time_accum -= _step
		_process_trail()

func _process_trail() -> void:
	global_position = Vector2.ZERO

	var point: Vector2 = parent.global_position + offset
	add_point(point, 0)

	if get_point_count() > length:
		remove_point(get_point_count() - 1)

func reset() -> void:
	clear_points()

func set_fps(value: float) -> void:
	fps = max(value, 1.0) # avoid div by zero
	_step = 1.0 / fps