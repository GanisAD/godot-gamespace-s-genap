class_name DummyTarget
extends CharacterBody2D

@export var max_health: float = 100

@onready var health_bar: ProgressBar = $HealthBar

var _current_health: float = 0

func _ready() -> void:
	_current_health = max_health
	health_bar.max_value = max_health

func _process(_delta: float) -> void:
	if _current_health <= 0:
		queue_free()
	
	health_bar.value = _current_health

func take_damage(damage: float) -> void:
	_current_health -= damage
