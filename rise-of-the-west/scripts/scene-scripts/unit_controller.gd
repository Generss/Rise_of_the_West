extends Node2D

var selected: Array[Unit] = []

var spacing := 40.0
var pressed := false

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and selected.size() != 0:
		if not pressed:
			move_selected_units(get_global_mouse_position())
		pressed = true
	else:
		pressed = false

func move_selected_units(center: Vector2) -> void:
	var unit_count := selected.size()

	var columns := int(ceil(sqrt(unit_count)))
	var rows := int(ceil(float(unit_count) / float(columns)))

	var formation_width := (columns - 1) * spacing
	var formation_height := (rows - 1) * spacing

	var top_left := center - Vector2(
		formation_width / 2.0,
		formation_height / 2.0
	)

	var unit_index := 0
	selected.shuffle()
	for y in range(rows):
		for x in range(columns):
			if unit_index >= unit_count:
				return
			var max_variation = 20 # you should keep this below 40
			var random_variation = Vector2(randf() * max_variation, randf() * max_variation)
			var destination := top_left + Vector2(
				x * spacing + random_variation.x,
				y * spacing + random_variation.y
			)

			selected[unit_index].move_to_target(destination)

			unit_index += 1


func _on_selection_box_selected_chosen(selected_list: Array[Unit]) -> void:
	selected = selected_list
