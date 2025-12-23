class_name Transition extends Node2D

@export var color : Color = Color.WHITE
@export var texture : Texture2D = null

var squares : Array[Sprite2D] = [] 

const COLUMNS : int = 32
const ROWS : int = 32
const TILE_SIZE : float = 24.0

signal animation_mid_point

func _ready() -> void:
	for x in ROWS:
		for y in COLUMNS:
			var square = Sprite2D.new()
			square.modulate = color
			square.texture = texture

			square.position.x = x * TILE_SIZE + TILE_SIZE / 2
			square.position.y = y * TILE_SIZE + TILE_SIZE / 2

			square.scale = Vector2.ZERO

			squares.append(square)

			add_child(square)

func animate() -> void:
	var per_square_duration : float = 0.2
	var wave_delay_step : float = 0.02

	var tween : Tween = create_tween()
	tween.set_parallel(true)

	tween.tween_callback(
		func(): animation_mid_point.emit()\
		)\
		.set_delay(wave_delay_step * COLUMNS + per_square_duration - 0.2)

	for i in range(squares.size()):
		var square = squares[i]
		square.modulate = color
		
		@warning_ignore("integer_division")
		var grid_x : int = i / COLUMNS
		var grid_y : int = i % COLUMNS

		var wave_index : int = grid_x + grid_y
		
		var start_delay : float = wave_index * wave_delay_step
		
		# Scale UP
		tween.tween_property(square, "scale", Vector2.ONE, per_square_duration)\
			.from(Vector2.ZERO)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_SPRING)\
			.set_delay(start_delay)

		tween.tween_property(square, "rotation_degrees", 90.0, per_square_duration * 0.5)\
			.from(0.0)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_delay(start_delay)

		var hold_time = 0.4
		tween.tween_property(square, "scale", Vector2.ZERO, per_square_duration)\
			.from(Vector2.ONE)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_delay(start_delay + per_square_duration + hold_time)

		tween.tween_property(square, "rotation_degrees", 180.0, per_square_duration)\
			.from(90.0)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_LINEAR)\
			.set_delay(start_delay + per_square_duration + hold_time)
