class_name EconomyUI
extends Control

@export var Balance: int
@export var Income: int
@export var Towns: int
@export var Mines: int
@export var Forts: int
@export var Units: int
@export var MaxPop: int


@export var EnemyBalance: int
@export var EnemyIncome: int
@export var EnemyTowns: int
@export var EnemyMines: int
@export var EnemyForts: int
@export var EnemyUnits: int
@export var EnemyMaxPop: int

var EndUnitsRecruited: int
var EndUnitsRecruitedEnemy: int

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

func set_values(values: Array[int]):
	var num: int = 0
	for child in get_children():
		if child is not Label:
			continue
		child.text = child.name + ": " + str(values[num])
		pass

func new_enemy_town(location: capturable):
	match location.type:
		"Town":
			EnemyTowns += 1
			EnemyMaxPop += 5
		"Fort":
			EnemyForts += 1
			EnemyMaxPop += 15
		"Mine":
			EnemyMines += 1
	EnemyIncome += location.income


func new_town(location: capturable):
	match location.type:
		"Town":
			Towns += 1
			MaxPop += 5
			get_node("Towns").text = "Towns: "+str(Towns)
			get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
		"Fort":
			Forts += 1
			MaxPop += 15
			get_node("Forts").text = "Forts: "+str(Forts)
			get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
		"Mine":
			Mines += 1
			get_node("Mines").text = "Mines: "+str(Mines)
	Income += location.income
	get_node("Income").text = "Income: "+str(Income)

func lose_town(location: capturable):
	match location.type:
		"Town":
			Towns -= 1
			MaxPop -= 5
			get_node("Towns").text = "Towns: "+str(Towns)
			get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
		"Fort":
			Forts -= 1
			MaxPop -= 15
			get_node("Forts").text = "Forts: "+str(Forts)
			get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
		"Mine":
			Mines -= 1
			get_node("Mines").text = "Mines: "+str(Mines)
	Income -= location.income
	get_node("Income").text = "Income: "+str(Income)

func lose_ememy_town(location: capturable):
	match location.type:
		"Town":
			EnemyTowns -= 1
			EnemyMaxPop -= 5

		"Fort":
			EnemyForts -= 1
			EnemyMaxPop -= 15

		"Mine":
			EnemyMines -= 1
	EnemyIncome -= location.income


func spend(money: int) -> bool:
	if Balance - money > 0 and MaxPop > Units:
		Units += 1
		Balance -= money
		get_node("Balance").text = "Balance: " + str(Balance)
		get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
		return true
	else:
		return false

func enemy_spend(money: int) -> bool:
	if EnemyBalance - money > 0 and EnemyMaxPop > EnemyUnits:
		EnemyUnits += 1
		EnemyBalance -= money
		return true
	else:
		return false


func lost_unit():
	print("lost")
	Units -= 1
	get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
	if Units == 0 and Towns + Forts == 0:
		print("Defeat")
		#%EndGameScreen.get_node("Message").text = "Defeat"
		#%EndGameScreen.visible = true

func enemy_lost_unit():
	EnemyUnits -= 1
	if EnemyUnits == 0 and EnemyTowns + Forts == 0:
		print("Victory")
		#%EndGameScreen.get_node("Message").label = "Victory"
		#%EndGameScreen.visible = true


func _on_income_timer_timeout() -> void:
	Balance += Income
	EnemyBalance += EnemyIncome
	get_node("Balance").text = "Balance: " + str(Balance)
