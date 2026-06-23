extends NinePatchRect

var selecting := false
var starting_position: Vector2


@onready var area_2d: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D



var selected: Array[Unit] = []
var units_in_box: Array[Unit] = []





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
	if area is Unit and visible:
		select_unit(area as Unit)
		units_in_box.append(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if selected.has(area) and visible:
		deselect_unit(area as Unit)
		units_in_box.erase(area)

func deselect_all(selected_units: Array[Unit]):
	for unit in selected_units:
		deselect_unit(unit)

func select_unit(unit: Unit) -> void:
		unit.selected = true
		unit.set_outline(2.0)
func deselect_unit(unit: Unit) -> void:
	unit.selected = false
	unit.set_outline(0.0)
	
