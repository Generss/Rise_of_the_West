class_name UnitCard
extends Control

@export var new_texture = preload("res://assets/CapturableAssets/PistolInfantryRecruitSymbol.png")
@export var revolverinfantry = preload("res://assets/CapturableAssets/PistolInfantryRecruitSymbol.png")
@export var cavalry = preload("res://assets/CapturableAssets/CavalryRecruitSymbol.png")
@export var dynamite = preload("res://assets/CapturableAssets/TNTRecruitSymbol.png")
@export var cannon = preload("res://assets/textures/ball.png")
@export var rifleman = preload("res://assets/CapturableAssets/RifleInfantryRecruitSymbol -.png")
@export var gatling = preload("res://assets/textures/gatlingrecruitment.png")
@export var health : int = 100
@export var unit: UnitBody

func _process(delta: float) -> void:
	if !is_instance_valid(unit):
		queue_free()
		return
	%HealthBar.value = unit.current_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.texture = new_texture
	%Panel.add_theme_stylebox_override("panel", new_stylebox)
	%HealthBar.value = health

func set_health(new_health: int):
	health = new_health
	get_node("ProgressBar").value = health
