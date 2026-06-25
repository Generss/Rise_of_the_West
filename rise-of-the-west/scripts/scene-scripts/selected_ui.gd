extends BoxContainer

@onready var selected: Array[Unit] = []

func _process(delta: float) -> void:
	for unit in selected:
		if unit == null:
			remove_unit(unit)
	get_node("Title").text = "Selected: " + str(selected.size())

func add_unit(unit: Unit):
	selected.append(unit)

func remove_unit(unit: Unit):
	selected.erase(unit)
	
func add_units(units:Array[Unit]):
	for unit in units:
		selected.append(unit)

func remove_units():
	selected.clear()
