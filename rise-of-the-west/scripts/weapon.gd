class_name Weapon
extends Node2D

@export var projectile_scene : PackedScene 
@export var fire_rate: float = 2.0

var active: bool = false
var time_since_fire: float = 0.0
var faction: String = "Ally"
var target: UnitBody = null


func _process(delta: float) -> void:
	if not active:
		return

	if target == null or not is_instance_valid(target):
		deactivate()
		return

	time_since_fire += delta

	if time_since_fire >= 1.0 / fire_rate:
		time_since_fire = 0.0
		fire_weapon()


func fire_weapon() -> void:
	var projectile := projectile_scene.instantiate() as Projectile

	get_tree().current_scene.add_child(projectile)

	projectile.global_position = global_position
	projectile.set_faction(faction)

	var direction := global_position.direction_to(target.global_position)
	projectile.activate_projectile(direction)


func activate(new_target: UnitBody) -> void:
	target = new_target
	active = true


func deactivate() -> void:
	active = false
	target = null
	time_since_fire = 0.0
