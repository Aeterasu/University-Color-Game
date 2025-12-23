class_name Main extends Node

enum State
{
	DEFAULT, # none
	GAME,
	BOOKLET,
}

@export var transition : Transition = null
var transition_lerp_y : float = 0.0
var transition_lerp_x : float = 0.0

@export_group("State")
@export var game_scene : PackedScene = null
@export var booklet_scene : PackedScene = null

var currently_loaded : Node = null
var current_state : State = State.DEFAULT

var is_loading : bool = false

static var instance : Main = null

func _ready() -> void:
	instance = self

	load_state(State.BOOKLET)

	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _physics_process(delta: float) -> void:
	if currently_loaded and currently_loaded is Node2D:
		currently_loaded.position.x = Jelly.jelly_preset(transition_lerp_x, 0.0, 0.0, Jelly.JellyPreset.BOUNCY)
		currently_loaded.position.y = Jelly.jelly_preset(transition_lerp_y, -12.0, 0.0, Jelly.JellyPreset.BOUNCY)

func load_state(state : State) -> void:
	get_tree().paused = false

	if is_loading:
		return

	is_loading = true

	transition.animate()
	await transition.animation_mid_point

	if currently_loaded:
		currently_loaded.queue_free()

	var node : Node = null

	match state:
		State.BOOKLET:
			node = booklet_scene.instantiate()
		State.GAME:
			node = game_scene.instantiate()

	if node:
		currently_loaded = node
		current_state = state
		add_child.call_deferred(node)

	is_loading = false

	if node is Node2D:
		var tween : Tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(self, "transition_lerp_y", 1.0, 2.0)\
			.from(0.0)
		tween.tween_property(self, "transition_lerp_x", 1.0, 1.6)\
			.from(0.0)
