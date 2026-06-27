extends Node2D

var selected: Array[Unit] = []

@export var selected_ui: Node

@export var max_variation: int = 25 # you should keep this below 40
@export var do_shuffle: bool = false

var spacing := 40.0
var pressed := false


func _ready() -> void:
	get_node("SelectionBox").selected_ui = selected_ui


func _process(_delta: float) -> void:
	clean_selected()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and selected.size() != 0:
		if not pressed:
			move_selected_units(get_global_mouse_position())
		pressed = true
	else:
		pressed = false


func move_selected_units(center: Vector2) -> void:
	clean_selected()

	var movable_units: Array[Unit] = []

	for unit in selected:
		if is_instance_valid(unit):
			movable_units.append(unit)

	if movable_units.is_empty():
		return

	if do_shuffle:
		movable_units.shuffle()

	var unit_count := movable_units.size()
	
	var columns := int(ceil(sqrt(unit_count)))
	var rows := int(ceil(float(unit_count) / float(columns)))
	
	var formation_width := (columns - 1) * spacing
	var formation_height := (rows - 1) * spacing
	
	var top_left := center - Vector2(
		formation_width / 2.0,
		formation_height / 2.0
	)
	
	var unit_index := 0
	
	for y in range(rows):
		for x in range(columns):
			if unit_index >= unit_count:
				return
				
			var unit := movable_units[unit_index]
			
			if not is_instance_valid(unit):
				unit_index += 1
				continue
				
			var random_variation := Vector2(
				randf() * max_variation,
				randf() * max_variation
			)
			
			var destination := top_left + Vector2(
				x * spacing + random_variation.x,
				y * spacing + random_variation.y
			)
			
			unit.move_to_target(destination)
			
			unit_index += 1


func clean_selected() -> void:
	selected = selected.filter(func(unit): return is_instance_valid(unit))


func _on_selection_box_selected_chosen(selected_list: Array[Unit]) -> void:
	selected = []
	
	for unit in selected_list:
		if is_instance_valid(unit):
			selected.append(unit)


func _on_selection_box_delete_unit(unit: Unit) -> void:
	if not is_instance_valid(unit):
		return
		
	selected.erase(unit)
	
	if selected_ui != null:
		selected_ui.remove_unit(unit.get_parent())
	
	var body := unit.get_parent() as UnitBody
	
	if body != null and is_instance_valid(body):
		body.die()
	else:
		unit.queue_free()
