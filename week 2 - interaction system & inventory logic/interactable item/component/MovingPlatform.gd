class_name MovingPlatform2D
extends AnimatableBody2D # Bagus untuk platform bergerak agar tidak 'mendorong' player secara kasar

@export var move_offset: Vector2 = Vector2(0, -100) # Seberapa jauh platform bergerak
@export var duration: float = 1.0 # Kecepatan gerak

var start_pos: Vector2
var is_active: bool = false

func _ready() -> void:
	start_pos = global_position

func toggle_platform(is_on: bool) -> void:
	is_active = is_on
	var target_pos = start_pos + move_offset if is_active else start_pos
	
	# Membuat animasi gerak halus menggunakan Tween
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", target_pos, duration)
