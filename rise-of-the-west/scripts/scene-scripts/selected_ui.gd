extends BoxContainer

var card_scene = preload("res://scenes/Selection/unit_card.tscn")

@onready var ally_units: Array[Unit] = []
@onready var selected: Array[Unit] = []
@onready var displayed: Array[Unit] = []

func _process(delta: float) -> void:
	for unit in selected:
		if unit == null:
			remove_unit(unit)
	

func add_unit(unit: Unit):
	print("added")
	selected.append(unit)
	var gridbox = get_node("GridContainer")
	var unitcard: UnitCard = card_scene.instantiate()
	gridbox.add_child(unitcard)

func remove_unit(unit: Unit):
	selected.erase(unit)
	
func add_units(units:Array[Unit]):
	for unit in units:
		selected.append(unit)
		add_unit(unit)

func remove_units():
	selected.clear()
	var gridbox = get_node("GridContainer")
	for child in gridbox.get_children():
		child.queue_free()
