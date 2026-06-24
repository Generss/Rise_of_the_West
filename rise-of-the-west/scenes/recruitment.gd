extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var parent_control := get_parent() as Control
	if parent_control:
		scale = (Vector2.ONE / parent_control.scale) * Vector2(0.4,0.4)
