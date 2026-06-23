extends CharacterBody2D

const SPEED = 300.0
const HP = 100.0
const ATTACK_SPEED = 1.0
const RELOAD_SPEED = 1.0
const DAMAGE = 10.0
const RANGE = 1200.0
var click_position = Vector2()
var target_position = Vector2()

func _ready():
	click_position = position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		click_position = get_global_mouse_position()
	if position.distance_to(click_position) > 3:
		target_position = (click_position - position).normalized()
		velocity = target_position * SPEED
		move_and_slide()
