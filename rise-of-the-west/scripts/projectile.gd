class_name Projectile
extends Area2D

@export var speed : float = 1000
@export var damage : int = 25
@export var pushing_power : float = 10

var desired_velocity : Vector2 = Vector2(0,0)
var faction : String = "Ally"
var direction : Vector2
@onready var sprite : Sprite2D = $Sprite2D 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	calculate_motion(delta)
	sprite.rotation = direction.angle()
	
func _on_area_entered(area: Area2D) -> void:
	if area is Unit:
		var unit = area as Unit
		if unit.faction != faction:
			var push_direction : Vector2 = direction.normalized()
			unit.push_unit(push_direction, pushing_power)
			unit.take_damage(damage)
			queue_free()

func activate_projectile(new_direction : Vector2 ):
	direction = new_direction
	desired_velocity = direction * speed

func calculate_motion(delta: float) -> void:
	global_position += desired_velocity * delta 
	
func set_faction(new_faction : String) -> void:
	faction = new_faction


func _on_lifetime_timer_timeout() -> void:
	queue_free()
