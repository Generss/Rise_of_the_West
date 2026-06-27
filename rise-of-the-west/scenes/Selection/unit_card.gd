class_name UnitCard
extends Control

@export var new_texture = preload("res://assets/CapturableAssets/PistolInfantryRecruitSymbol.png")
@export var health : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_stylebox = StyleBoxTexture.new()
	new_stylebox.texture = new_texture
	%Panel.add_theme_stylebox_override("panel", new_stylebox)
	%HealthBar.value = health

func set_health(new_health: int):
	health = new_health
	get_node("ProgressBar").value = health
