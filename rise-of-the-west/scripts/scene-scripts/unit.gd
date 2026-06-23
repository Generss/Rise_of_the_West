class_name Unit
extends Area2D

var selected := true
var target : Vector2
var following_target := false
var speed : float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var click_occured = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
	if selected and click_occured:
		target = get_global_mouse_position()
		following_target = true
		click_occured = false
	
	if following_target:
		if(global_position.distance_to(target) < 10):
			following_target = false
		else: 
			var true_speed : float = speed * delta
			global_position = global_position.move_toward(target,true_speed) 
		
		
		
	
