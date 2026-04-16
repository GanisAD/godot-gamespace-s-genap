class_name DummyTarget
extends CharacterBody2D

@export var max_health: float = 100
@export var friction: float = 10.0
@export var gravity: float = 980.0

@onready var health_bar: ProgressBar = $HealthBar

var _current_health: float = 0
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	_current_health = max_health
	health_bar.max_value = max_health

func _process(_delta: float) -> void:
	if _current_health <= 0:
		queue_free()
	
	health_bar.value = _current_health

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if knockback_velocity != Vector2.ZERO:

		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, friction * delta)
		
		if knockback_velocity.length() < 10:
			knockback_velocity = Vector2.ZERO	   
		
		velocity.x = knockback_velocity.x
		
	move_and_slide()

func take_damage(damage: float, k_force: float = 0.0, k_direction: Vector2 = Vector2.ZERO) -> void:
	_current_health -= damage
	
	knockback_velocity = k_direction * k_force
	if _current_health <= 0:
		die()
		
func die() -> void:
	queue_free()
