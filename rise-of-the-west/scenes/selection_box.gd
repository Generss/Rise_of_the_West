extends NinePatchRect

var selecting := false
var starting_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not selecting:
			starting_position = get_global_mouse_position()
			selecting = true
			visible = true
		var current_position = get_global_mouse_position()
		
		var top_left := Vector2(min(starting_position.x,current_position.x), min(starting_position.y,current_position.y))
		var bottom_right := Vector2(max(starting_position.x,current_position.x), max(starting_position.y,current_position.y))
		global_position = top_left
		size = bottom_right - top_left
	else:
		selecting = false
		visible = false
			
			
