extends Control

@export var map_scene: PackedScene
var map_instance
var _active_game : bool = false

func _ready() -> void:
	$Menu/MenuButtons/Control/BoxContainer/Resume.hide()

# IN GAME PAUSING START
func _on_resume_pressed() -> void:
	toggle_menu()

func _unhandled_input(event):
	if event.is_action_pressed("escape") and _active_game:
		toggle_menu()

func toggle_menu():
	visible = !visible
	get_tree().paused = visible
# IN GAME PAUSING END

# EXIT GAME
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_play_pressed() -> void: 
	if _active_game:
		_cleanup_game()
		_new_game()
	else:
		_new_game()
		_active_game = true
		$Menu/MenuButtons/Control/BoxContainer/Resume.show()
		
func _new_game():
	map_instance = map_scene.instantiate()
	var grandparent_node = get_parent().get_parent()
	grandparent_node.add_child(map_instance)
	

func _cleanup_game():
	map_instance.queue_free()
