class_name Projectile2D
extends Area2D

@export var projectile_speed: float = 200
@export var projectile_damage: float = 10
@export var knockback_force: float = 300.0

func _ready() -> void:
	body_entered.connect(_on_body_enter)

func set_projectile_speed(speed: float) -> void:
	projectile_speed = speed

func set_projectile_damage(damage: float) -> void:
	projectile_damage = damage

func _physics_process(delta: float) -> void:
	global_position.x += projectile_speed * delta

func _on_body_enter(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
	
	if body.is_in_group("Enemy"):
		if body.has_method("take_damage"):
			var knockback_dir = global_position.direction_to(body.global_position)
			body.take_damage(projectile_damage, knockback_force, knockback_dir)
			
		queue_free()
