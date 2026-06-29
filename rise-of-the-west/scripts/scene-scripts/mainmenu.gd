extends Control

@export var map_scene: PackedScene
var map_instance
var _active_game : bool = false
@onready var base_population:int = %Population.value
@onready var deathmatch: bool = false

func _ready() -> void:
	$Menu/MenuButtons/Control/BoxContainer/Resume.hide()
	%MusicHandler.change_track("title")

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
	%Options.visible = true
	%MenuButtons.visible=false

func _on_play_pressed() -> void: 
	if _active_game:
		_cleanup_game()
		_new_game()
	else:
		_new_game()
		_active_game = true
		%MainMenuBackGround.visible = false
		$Menu/MenuButtons/Control/BoxContainer/Resume.show()
		
func _new_game():
	map_instance = map_scene.instantiate()
	map_instance.PopulationBase = base_population
	if(deathmatch):
		map_instance.DeathMatch = true
	var grandparent_node = get_parent().get_parent()
	grandparent_node.add_child(map_instance)
	toggle_menu()
	%MusicHandler.change_track("desert")
	

func _cleanup_game():
	map_instance.queue_free()


func _on_back_pressed() -> void:
	%Options.visible = false
	%MenuButtons.visible=true


func _on_population_value_changed(value: float) -> void:
	base_population = int(value)


func _on_death_match_pressed() -> void:
	deathmatch = !deathmatch


func _on_guide_pressed() -> void:
	%MenuButtons.visible=false
	%Guide.visible = true


func _on_guide_back_pressed() -> void:
	%MenuButtons.visible=true
	%Guide.visible = false
