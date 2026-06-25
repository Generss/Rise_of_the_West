extends Control

@export var Balance: int
@export var Income: int
@export var Towns: int
@export var Mines: int
@export var Forts: int
@export var Units: int
@export var MaxPop: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Balance").text = "Balance: "+str(Balance)
	get_node("Income").text = "Income: "+str(Income)
	get_node("Towns").text = "Towns: "+str(Towns)
	get_node("Mines").text = "Mines: "+str(Mines)
	get_node("Forts").text = "Forts: "+str(Forts)
	get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_capturable_faction_change(location: capturable, faction: String) -> void:
	if faction == "player":
		Towns += 1
	Income = Towns * 10
		
func set_values(values: Array[int]):
	var num: int = 0
	for child in get_children():
		if child is not Label:
			continue
		child.text = child.name + ": " + str(values[num])
		pass

func new_town(location: capturable):
	Income += 10
	Towns += 1
	MaxPop += 5
	get_node("Income").text = "Income: "+str(Income)
	get_node("Towns").text = "Towns: "+str(Towns)
	get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)

func spend(money: int) -> bool:
	if Balance - money > 0 and MaxPop > Units:
		Units += 1
		Balance -= money
		get_node("Balance").text = "Balance: " + str(Balance)
		get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
		return true
	else:
		return false

func lost_unit():
	Units -= 1
	get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)

func _on_income_timer_timeout() -> void:
	Balance += Income
	get_node("Balance").text = "Balance: " + str(Balance)
