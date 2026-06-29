extends Node2D

@onready var capture_controller : CapturableController = %CapturableController
@onready var DeathMatch: bool

var time: float = 0
var frequency: float = 4

func _ready() -> void:
	DeathMatch = get_parent().DeathMatch
	if DeathMatch:
		frequency = 2

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > frequency:
		print(str(time))
		time = 0
	else:
		return
	var my_capturables: Array[capturable] = capture_controller.enemy_capturables.duplicate()
	if my_capturables.is_empty():
		return
	for capture in my_capturables:
		# Panic Recruitment
		if %EconomyUI.EnemyUnits < 10 and (capture.type == "Fort" or capture.type == "Town"):
			for i in range(9):
				capture.enemy_recruitment()
		elif %EconomyUI.EnemyForts+%EconomyUI.EnemyTowns+%EconomyUI.EnemyMines==1:
			for i in range(9):
				capture.enemy_recruitment()
		capture.enemy_recruitment()
