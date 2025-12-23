class_name Game extends Node

@export var label_center : Control = null
@export var label : Label = null
@export var padding : Control = null
var current_question : Question = null

@export var time_progress_bar : TextureProgressBar = null
var time_limit : TimeLimit = null

@export var score_label : Label = null
@export var best_label : Label = null
var scoring : Scoring = null

@export var flash : ColorRect = null

var answer_count : int = 0

var game_over : bool = false
var await_restart_input : bool = false
@export var game_over_screen : Control = null
@export var game_over_score_label : Label = null
@export var game_over_best_label : Label = null
@export var game_over_screen_backdrop : Sprite2D = null
@export var texture_game_over_screen_red : Texture2D = null
@export var texture_game_over_screen_blue : Texture2D = null
@export var texture_game_over_screen_green : Texture2D = null

@export var particles : CPUParticles2D = null

@export var screen_shake : ShakyNode2D = null

@export var transition : Transition = null

func _ready() -> void:
	scoring = Scoring.new()
	time_limit = TimeLimit.new()
	time_limit.on_ran_out_of_time.connect(on_ran_out_of_time)

	transition.animation_mid_point.connect(on_game_over_transition)

	add_child(time_limit)

	game_over_screen.hide()

	generate_new_question()

func _input(event: InputEvent) -> void:
	if event.is_pressed() and (event is InputEventKey):
		if event.physical_keycode == KEY_F1:
			generate_new_question()

func _physics_process(delta: float) -> void:
	if game_over:
		if await_restart_input and \
			(Input.is_action_just_pressed("input_confirm") or \
			Input.is_action_just_pressed("input_deny")):
				Main.instance.load_state(Main.State.GAME)
				await_restart_input = false

		return

	if current_question:
		time_progress_bar.min_value = 0.0
		time_progress_bar.max_value = time_limit.base_limit
		time_progress_bar.value = time_limit.time_left

	if scoring:
		score_label.text = "\n" + str(scoring.score)
		best_label.text = "\n" + str(Scoring.personal_best)

		game_over_score_label.text = "SCORE: " + str(scoring.score)
		game_over_best_label.text = "BEST: " + str(Scoring.personal_best)

	if Input.is_action_just_pressed("input_confirm"):
		confirm()

	if Input.is_action_just_pressed("input_deny"):
		deny()

func generate_new_question() -> void:
	if answer_count == 0:
		current_question = Question.new()
		current_question.text_color = Stroop.Colors.RED
		current_question.display_name = Stroop.Colors.RED
	elif answer_count == 1:
		current_question = Question.new()
		current_question.text_color = Stroop.Colors.GREEN
		current_question.display_name = Stroop.Colors.GREEN
	elif answer_count == 2:
		current_question = Question.new()
		current_question.text_color = Stroop.Colors.BLUE
		current_question.display_name = Stroop.Colors.BLUE
	else:
		current_question = Question.generate_new_question()

	label.label_settings.font_color = Stroop.get_color_value(current_question.text_color)
	label.text = Stroop.get_color_name(current_question.display_name)

	answer_count += 1

	# animate this

	var tween : Tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(label_center, "position", Vector2.ZERO, 0.3)\
		.from(Vector2.UP * 32.0)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(label_center, "scale", Vector2.ONE, 0.2)\
		.from(Vector2.ONE * 2.0)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(padding, "position", Vector2(0.0, 72.0), 0.3)\
		.from(Vector2(0.0, 72.0) + Vector2.UP * 32.0)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	var create_particles = func(): 
		var p = particles.duplicate()
		add_child(p)
		p.global_position = Vector2(320.0 * 0.5, 180.0 * 0.5)
		p.emitting = true
		p.modulate = Stroop.get_color_value(current_question.text_color)

	tween.tween_callback(create_particles).set_delay(0.1)

	var flash_tween : Tween = create_tween()
	flash_tween.tween_property(flash, "modulate:a", 0.8, 0.05).from(0.0)
	flash_tween.tween_property(flash, "modulate:a", 0.0, 0.5).from(0.8)

func confirm() -> void:
	if not current_question:
		return

	if current_question.text_color == current_question.display_name:
		on_correct_answer()
	else:
		on_wrong_answer()

func deny() -> void:
	if not current_question:
		return

	if current_question.text_color != current_question.display_name:
		on_correct_answer()
	else:
		on_wrong_answer()

func on_correct_answer() -> void:
	generate_new_question()
	time_limit.reset()

	scoring.award_score()

func on_wrong_answer() -> void:
	fail()

func on_ran_out_of_time() -> void:
	fail()

func fail() -> void:
	screen_shake.shake(4.0)

	time_limit.is_stopped = true
	game_over = true

	transition.color = Stroop.get_color_value(current_question.text_color)
	transition.animate()

	var texture : Texture2D = texture_game_over_screen_red

	match current_question.text_color:
		Stroop.Colors.RED:
			texture = texture_game_over_screen_red
		Stroop.Colors.GREEN:
			texture = texture_game_over_screen_green
		Stroop.Colors.BLUE:
			texture = texture_game_over_screen_blue
	
	game_over_screen_backdrop.texture = texture

	get_tree().create_timer(0.8).timeout.connect(func(): await_restart_input = true)

func on_game_over_transition() -> void:
	game_over_screen.show()
