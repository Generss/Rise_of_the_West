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
var EndMoney: int
var EndMoneyEnemy: int
var GameTime: float
var GameOver: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene_root = owner 
	if owner.DeathMatch:
		Balance = 20000
		EnemyBalance = 20000
	get_node("Balance").text = "Balance: "+str(Balance)
	get_node("Income").text = "Income: "+str(Income)
	get_node("Towns").text = "Towns: "+str(Towns)
	get_node("Mines").text = "Mines: "+str(Mines)
	get_node("Forts").text = "Forts: "+str(Forts)
	MaxPop = owner.PopulationBase
	EnemyMaxPop = MaxPop
	get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GameTime += delta

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
	if Units == 0 and Towns + Forts + Mines == 0:
		end_game(false)

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
	if EnemyUnits == 0 and EnemyTowns + EnemyForts + EnemyMines == 0:
		end_game(true)


func spend(money: int) -> bool:
	if Balance - money > 0 and MaxPop > Units:
		Units += 1
		Balance -= money
		get_node("Balance").text = "Balance: " + str(Balance)
		get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
		EndUnitsRecruited += 1
		return true
	else:
		return false

func enemy_spend(money: int) -> bool:
	if EnemyBalance - money > 0 and EnemyMaxPop > EnemyUnits:
		EnemyUnits += 1
		EnemyBalance -= money
		EndUnitsRecruitedEnemy += 1
		return true
	else:
		return false


func lost_unit():
	print("lost")
	Units -= 1
	get_node("Population").text = "Pop: "+str(Units) +"/" +str(MaxPop)
	if Units == 0 and Towns + Forts + Mines == 0:
		end_game(false)

func enemy_lost_unit():
	EnemyUnits -= 1
	if EnemyUnits == 0 and EnemyTowns + EnemyForts + EnemyMines == 0:
		end_game(true)

func end_game(PlayerWin:bool):
	print("Game ended")
	if GameOver:
		return
	GameOver = true
	if PlayerWin:
		%WinMessage.text = "Victory"
	else:
		%WinMessage.text = "Defeat"
	var minutes: int = int(GameTime) / 60
	var seconds: int = int(GameTime) % 60
	var statsstring : String = "Time: " + str(minutes)+" minutes " + str(seconds) +" seconds\n"
	statsstring += "Player Units Recruited: "+str(EndUnitsRecruited) + "\nEnemy Units Recruited: "+str(EndUnitsRecruitedEnemy)+"\n"
	statsstring += "Money Earned by Player: "+str(EndMoney)+"\nMoney Earned by Enemy: "+str(EndMoneyEnemy)
	%Stats.text = statsstring
	%WinMessage.visible = true
	%Stats.visible = true

func _on_income_timer_timeout() -> void:
	Balance += Income
	EndMoney += Income
	EnemyBalance += EnemyIncome
	EndMoneyEnemy += EnemyIncome
	get_node("Balance").text = "Balance: " + str(Balance)


func _on_console_text_submitted(new_text: String) -> void:
	%Console.clear()
	match new_text:
		"money":
			Balance += 1000
			get_node("Balance").text = "Balance: " + str(Balance)
		"moneymoney":
			Balance += 10000
			get_node("Balance").text = "Balance: " + str(Balance)
		"moneymoneymoney":
			Balance += 100000
			get_node("Balance").text = "Balance: " + str(Balance)
		"win":
			end_game(true)
		"lose":
			end_game(false)
		"killall":
			for unit in %Sortable.get_children():
				if unit is UnitBody:
					unit.die()
		"killallenemy":
			for unit in %Sortable.get_children():
				if unit is UnitBody and unit.faction == "Enemy":
					unit.die()
		"killallplayer":
			for unit in %Sortable.get_children():
				if unit is UnitBody and unit.faction == "Ally":
					unit.die()
		"decap":
			for capturable in %CapturableController.get_children():
				if capturable.value == 200.0:
					lose_town(capturable)
				elif capturable.value == 0.0:
					lose_ememy_town(capturable)
				capturable.faction = "Neutral"
				capturable.value = 100.0
		"decapplayer":
			for capturable in %CapturableController.get_children():
				if capturable.value == 200.0:
					lose_town(capturable)
					capturable.faction = "Neutral"
					capturable.value = 100.0
		"decapenemy":
			for capturable in %CapturableController.get_children():
				if capturable.value == 0.0:
					lose_town(capturable)
					capturable.faction = "Neutral"
					capturable.value = 100.0
