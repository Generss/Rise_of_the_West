class_name capturable
extends NinePatchRect

@export var value: int = 100
@export var income: int = 10
@export var income_fixed: bool = true
@export var type: String = "Town"
@export var faction: String = "neutral"

@export var ally_units_in_box: Array[Unit] = []
@export var enemy_units_in_box: Array[Unit] = []


var _light = load("res://assets/CapturableAssets/lightbox.png")
var _dark = load("res://assets/CapturableAssets/darkbox.png")
var _neutral = load("res://assets/CapturableAssets/neutralbox.png")

var soldier_scene = load("res://scenes/Units/unit_body.tscn")
@onready var _sortable_node: Node2D = %Sortable

signal faction_change(location: capturable, faction: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	$ProgressBar.value = value

func _on_timer_timeout() -> void:
	if value < 200:
		var unit_count: int = ally_units_in_box.size() - enemy_units_in_box.size()
		var potential = value + unit_count * 2
		if potential < 200.0 and potential > 0.0:
			if unit_count > 0:
				print(value)
			value = potential
		elif potential >= 200.0:
			value = 200.0
			faction = "player"
			faction_change.emit(self, faction)
			self.texture = _light
			$Timer.stop()
		else:
			value = 0.0
			faction = "enemy"
			self.texture = _dark
			$Timer.stop()
		# Optional: Cast to int for printing if you don't want decimals in your logs
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


func _on_recruitment_gui_input(event: InputEvent) -> void:
	if value != 200:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if !%EconomyUI.spend(100):
			return
		var soldier_instance = soldier_scene.instantiate()
		var dimensions: Vector2 = size
		var random_variation = Vector2(randi_range(0, dimensions.x), randi_range(0, dimensions.y))
		soldier_instance.position = global_position + random_variation
		_sortable_node.add_child(soldier_instance)
