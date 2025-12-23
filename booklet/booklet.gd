class_name Booklet extends Node

@export var camera : Camera2D = null

@export var rich_text : RichTextLabel = null
@export var gradient : Gradient = null

var booklet_stage : int = 0

var gradient_offset : float = 0.0

func _ready() -> void:
	camera.global_position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("input_confirm") or\
		Input.is_action_just_pressed("input_deny"):
			booklet_stage += 1

			Main.instance.audio_whoosh.play()

			if booklet_stage == 2:
				Main.instance.load_state(Main.State.GAME)
				return

			var tween : Tween = create_tween()
			tween.tween_property(camera, "position", Vector2(0.0, 180.0), 1.0)\
				.set_trans(Tween.TRANS_EXPO)\
				.set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	gradient_offset += delta

	if gradient_offset >= 1.0:
		gradient_offset = 0.0

	var color = gradient.sample(gradient_offset)
	var hex : String = color.to_html()

	rich_text.text = "[center]Words will appear on the screen in different [color=" + hex + "]colors.[/color]\n\n" + \
		"If the word matches its [color=" + hex + "]color[/color], click the left button. \n If it doesn’t match, click the right button." + \
		"\n\nRespond as quickly as you can and score points!"
