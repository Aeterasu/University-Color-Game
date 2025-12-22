class_name BackdropLayer extends Sprite2D

@export var speed : Vector2 = Vector2.DOWN

func _ready() -> void:
    region_enabled = true

func _process(delta: float) -> void:
    region_rect.position += speed * delta