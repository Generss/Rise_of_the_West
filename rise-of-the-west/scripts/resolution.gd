extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(720, 480))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
