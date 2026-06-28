extends NinePatchRect


signal selected_chosen(selected_list : Array[Unit])


@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

var selected_ui: Node

var selecting := false
var starting_position: Vector2

@onready var selected: Array[Unit] = []
@onready var units_in_box: Array[Unit] = []

signal delete_unit(unit: Unit)

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
			deselect_all(selected)
		var current_position = get_global_mouse_position()
		
		var top_left := Vector2(min(starting_position.x,current_position.x), min(starting_position.y,current_position.y))
		var bottom_right := Vector2(max(starting_position.x,current_position.x), max(starting_position.y,current_position.y))
		global_position = top_left
		size = bottom_right - top_left
		update_collision_shape(size)
	else:
		if selecting:
			selected = units_in_box.duplicate()
			selected_chosen.emit(selected.duplicate())
		units_in_box.clear()
		selecting = false
		visible = false

func update_collision_shape(rect_size: Vector2) -> void:
	var rectangle_shape := collision_shape.shape as RectangleShape2D

	if rectangle_shape == null:
		return

	rectangle_shape.size = rect_size
	area_2d.position = Vector2.ZERO
	collision_shape.position = rect_size / 2.0


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not visible:
		return
	
	if area is not Unit:
		return
	
	var unit := area as Unit
	
	if unit.faction == "Enemy":
		return
		
	select_unit(unit)
	units_in_box.append(unit)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Unit and visible:
		deselect_unit(area as Unit)
		units_in_box.erase(area)

func deselect_all(selected_units: Array[Unit]) -> void:
	clean_unit_arrays()
	for unit in selected_units:
		if is_instance_valid(unit):
			deselect_unit(unit)
	selected_units.clear()
	if selected_ui != null:
		selected_ui.remove_units()


func select_unit(unit: Unit) -> void:
	if unit.faction == "Enemy":
		return
	clean_unit_arrays()
	if not is_instance_valid(unit):
		return
	
	unit.selected = true
	unit.set_outline(2.0)
	
	if selected_ui != null:
		selected_ui.add_unit(unit.get_parent())

func deselect_unit(unit: Unit) -> void:
	clean_unit_arrays()
	if not is_instance_valid(unit):
		return
		
	unit.selected = false
	unit.set_outline(0.0)
	

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("delete"):
		if selected.size()>0:
			for unit in selected:
				delete_unit.emit(unit)
			selected.clear()

func clean_unit_arrays() -> void:
	selected = selected.filter(func(unit): return is_instance_valid(unit))
	units_in_box = units_in_box.filter(func(unit): return is_instance_valid(unit))
