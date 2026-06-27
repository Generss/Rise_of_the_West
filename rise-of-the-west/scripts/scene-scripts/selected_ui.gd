extends BoxContainer

var card_scene = preload("res://scenes/Selection/unit_card.tscn")

@onready var selected: Array[Unit] = []

@onready var gridbox: GridContainer = $GridContainer


func _process(_delta: float) -> void:
	clean_dead_units()


func add_unit(unit: Unit) -> void:
	if not is_instance_valid(unit):
		return
	
	if selected.has(unit):
		return
	
	selected.append(unit)
	
	var unitcard: UnitCard = card_scene.instantiate()
	gridbox.add_child(unitcard)
	
	update_layout()


func remove_unit(unit: Unit) -> void:
	selected.erase(unit)
	rebuild_cards()


func add_units(units: Array[Unit]) -> void:
	remove_units()
	
	for unit in units:
		add_unit(unit)


func remove_units() -> void:
	selected.clear()
	
	for child in gridbox.get_children():
		child.queue_free()
	
	scale = Vector2.ONE
	gridbox.columns = 20


func clean_dead_units() -> void:
	var found_dead_unit := false
	
	for unit in selected:
		if not is_instance_valid(unit):
			found_dead_unit = true
			break

	if not found_dead_unit:
		return
	
	selected = selected.filter(func(unit): return is_instance_valid(unit))
	rebuild_cards()


func rebuild_cards() -> void:
	for child in gridbox.get_children():
		child.queue_free()
	
	for unit in selected:
		if not is_instance_valid(unit):
			continue
		
		var unitcard: UnitCard = card_scene.instantiate()
		gridbox.add_child(unitcard)

	update_layout()


func update_layout() -> void:
	if selected.size() > 10:
		var new_scale := 1.0 / (log(selected.size()) / log(10.0))
		scale = Vector2(new_scale, new_scale)
	else:
		scale = Vector2.ONE
	
	gridbox.columns = 20
	
	if selected.size() > 10:
		gridbox.columns += selected.size() / 11
