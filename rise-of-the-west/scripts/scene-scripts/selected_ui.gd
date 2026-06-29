extends BoxContainer

var card_scene = preload("res://scenes/Selection/unit_card.tscn")

@onready var selected: Array[UnitBody] = []

@onready var gridbox: GridContainer = $GridContainer

func add_unit(unit: UnitBody) -> void:
	if not is_instance_valid(unit):
		return
	
	if selected.has(unit):
		return
	
	selected.append(unit)
	
	var unitcard: UnitCard = card_scene.instantiate()
	unitcard.unit = unit
	match unit.unit_type:
		"Rifleman":
			unitcard.new_texture = unitcard.rifleman
		"Cannon":
			unitcard.new_texture = unitcard.cannon
		"Dynamite":
			unitcard.new_texture = unitcard.dynamite
		"Cavalry":
			unitcard.new_texture = unitcard.cavalry
		"RevolverInfantry":
			unitcard.new_texture = unitcard.revolverinfantry
		"Gatling":
			unitcard.new_texture = unitcard.gatling
	#unitcard.new_texture = 
	gridbox.add_child(unitcard)
	
	update_layout()


func remove_unit(unit: UnitBody) -> void:
	selected.erase(unit)


func add_units(units: Array[UnitBody]) -> void:
	remove_units()
	
	for unit in units:
		add_unit(unit)


func remove_units() -> void:
	selected.clear()
	
	for child in gridbox.get_children():
		child.queue_free()
	
	scale = Vector2.ONE
	gridbox.columns = 20

func update_layout() -> void:
	if selected.size() > 10:
		var new_scale := 1.0 / (log(selected.size()) / log(10.0))
		scale = Vector2(new_scale, new_scale)
	else:
		scale = Vector2.ONE
	
	gridbox.columns = 20
	
	if selected.size() > 10:
		gridbox.columns += selected.size() / 11
