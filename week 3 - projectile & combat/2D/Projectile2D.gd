class_name Projectile2D
extends Area2D

var projectile_speed: float = 200
var projectile_damage: float = 10

func _ready() -> void:
	body_entered.connect(_on_body_enter)

func set_projectile_speed(speed: float) -> void:
	projectile_speed = speed

func set_projectile_damage(damage: float) -> void:
	projectile_damage = damage

func _process(delta: float) -> void:
	global_position.x += projectile_speed * delta

func _on_body_enter(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
	
	if body.is_in_group("Enemy"):
		if body.has_method("take_damage"):
			body.take_damage(projectile_damage)
			
		queue_free()
