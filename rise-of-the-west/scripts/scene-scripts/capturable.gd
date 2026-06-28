class_name capturable
extends NinePatchRect

@export var value: int = 100
@export var income: int = 10
@export var income_fixed: bool = true
@export var type: String = "Town"
@export var faction: String = "Neutral"

@export var ally_units_in_box: Array[Unit] = []
@export var enemy_units_in_box: Array[Unit] = []


var _light = load("res://assets/CapturableAssets/lightbox.png")
var _dark = load("res://assets/CapturableAssets/darkbox.png")
var _neutral = load("res://assets/CapturableAssets/neutralbox.png")

var soldier_scene = load("res://scenes/Units/unit_body.tscn")
var rifle_scene = load("res://scenes/Units/unit_rifleman.tscn")
var cavalry_scene = load("res://scenes/Units/unit_calvary.tscn")
var tnt_scene = load("res://scenes/Units/unit_dynamite.tscn")
var cannon_scene = load("res://scenes/Units/unit_cannon.tscn")
var gatling_scene = load("res://scenes/Units/unit_gatling.tscn")
@onready var _sortable_node: Node2D = %Sortable

var infantry_choices: Array[PackedScene] = [soldier_scene, rifle_scene,]
var artillery_choices : Array[PackedScene] = [cannon_scene, gatling_scene]
var town_choices : Array[PackedScene] = [soldier_scene, cavalry_scene]

signal faction_change(location: capturable)

@export var economyui : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$Timer.start()
	$ProgressBar.value = value
	if type == "Fort":
		%CannonRecruitment.visible = true
		%GatlingRecruitment.visible = true
		%RifleRecruitment.visible = true
	if type == "Town":
		%CavalryRecruitment.visible = true
	if type == "Mine":
		%TNTRecruitment.visible = true
		%PistolRecruitment.visible = false

# Should only emit faction change signal WHEN IT CHANGES
func _on_timer_timeout() -> void:
	var unit_count: int = ally_units_in_box.size() - enemy_units_in_box.size()
	
	#First set of checks determine if point is fully captured
	if unit_count == 0:
		return
	if value == 200.0 and unit_count >= 0:
		return
	if value == 0.0 and unit_count <= 0:
		return
	
	var potential = value + unit_count * 8
	if potential < 200.0 and potential > 0.0:
		if faction == "Ally" or faction == "Enemy":
			faction = "Neutral"
			faction_change.emit(self)
		value = potential
	elif potential >= 200.0:
		value = 200.0
		faction = "Ally"
		faction_change.emit(self)
		self.texture = _light
	else:
		value = 0.0
		faction = "Enemy"
		faction_change.emit(self)
		self.texture = _dark
	$ProgressBar.value = value
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Unit and visible:
		if area.faction == "Ally":
			ally_units_in_box.erase(area)
		elif area.faction == "Enemy":
			enemy_units_in_box.erase(area)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Unit and visible:
		if area.faction == "Ally":
			ally_units_in_box.append(area)
		elif area.faction == "Enemy":
			enemy_units_in_box.append(area)

func enemy_recruitment() -> void: 
	var choice: PackedScene
	if type == "Fort":
		var random_int = randi_range(0,100)
		if random_int % 10 == 0:
			choice = artillery_choices.pick_random()
		else:
			choice = infantry_choices.pick_random()
	elif type == "Town":
		choice = town_choices.pick_random()
	elif type == "Mine":
		choice = tnt_scene
	_recruit(choice, true)

func _on_recruitment_gui_input(event: InputEvent) -> void:
	_recruit_handle(event, soldier_scene)

func _on_cannon_recruitment_gui_input(event: InputEvent) -> void:
	_recruit_handle(event, cannon_scene)


func _on_rifle_recruitment_gui_input(event: InputEvent) -> void:
	_recruit_handle(event, rifle_scene)


func _on_cavalry_recruitment_gui_input(event: InputEvent) -> void:
	_recruit_handle(event, cavalry_scene)


func _on_tnt_recruitment_gui_input(event: InputEvent) -> void:
	_recruit_handle(event, tnt_scene)


func _on_gatling_recruitment_gui_input(event: InputEvent) -> void:
	_recruit_handle(event, gatling_scene)

func _recruit(scene: PackedScene, enemy: bool = false):
	var price: int = 100
	match scene:
		soldier_scene:
			price = 100
		rifle_scene:
			price = 100
		cavalry_scene:
			price = 200
		tnt_scene:
			price = 500
		cannon_scene:
			price = 1000
		gatling_scene:
			price = 1200
	if !enemy:
		print("ally")
		if !%EconomyUI.spend(price):
			return
	else:
		price = 100 # Handicap for enemy, otherwise they'll never recruit advanced units
		if !%EconomyUI.enemy_spend(price):
			return
	var instance = scene.instantiate()
	var dimensions: Vector2 = size
	var random_variation = Vector2(randi_range(0, dimensions.x), randi_range(0, dimensions.y))
	instance.position = global_position + random_variation
	instance.economyui = economyui
	if enemy:
		instance.faction = "Enemy"
	else:
		instance.faction = "Ally"
	_sortable_node.add_child(instance)

func _recruit_handle(event: InputEvent, scene:PackedScene) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if event.shift_pressed:
			for i in range(9):
				_recruit(scene, false)
		_recruit(scene, false)
