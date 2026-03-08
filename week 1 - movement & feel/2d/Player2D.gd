class_name Player2D
extends CharacterBody2D
## Player Class
##
## Player class digunakan untuk mengontrol semua pergerakan dari player. Mulai dari jump, move, dll.
@export var animation: AnimatedSprite2D = null

@export_group("Player Data")
@export var move_speed: float = 0
@export var jump_force: float = 0
@export var friction: float = 0
@export var acceleration: float = 0

@export_group("Movement Multiplier")
@export var gravity_mult: float = 0
@export var speed_mult: float = 0
@export var jump_mult : float = 0

@export_group("Movement Feel")
@export var coyote_time: float = 0
@export var jump_buffer: float = 0

@export_group("Weight Modifier")
@export var max_weight: float = 100.0
@export var current_weight: float = 0.0 
@export var weight_penalty_factor: float = 0.7

var _direction: float = 0
var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0

## Fungsi Process ini digunakan untuk memproses game secara terus menerus tanpa henti
## sampai game dihentikan
func _process(_delta: float) -> void:
	_animation()

## Fungsi Physics Process digunakan untuk memproses game secara terus menerus juga, namun di fungsi ini
## ada tambahan proses fisika (Grivtasi, Velocity, dll)
func _physics_process(delta: float) -> void:
	
	var weight_ratio = clamp(current_weight / max_weight, 0.0, 1.0)
	var total_weight_mod = 1.0 - (weight_ratio * weight_penalty_factor)
	
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_mult
		_coyote_timer -= delta
	else:
		_coyote_timer = coyote_time
	
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer
	
	_jump_buffer_timer -= delta
	
	_jump(total_weight_mod)
	_move(total_weight_mod, delta)
	move_and_slide() ## (PENTING !!) fungsi untuk meng eksekusi proses fisika

## fungsi buatan sendiri yang mengatur move
func _move(mod: float, delta: float) -> void:
	_direction = Input.get_axis("left", "right")
	
	var target_speed = move_speed * _direction * speed_mult * mod
	var current_accel = acceleration * delta * mod
	
	if _direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, current_accel)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

## fungsi buatan sendiri yang mengatur jump
func _jump(mod: float) -> void:
	
	if _jump_buffer_timer > 0 and _coyote_timer > 0:
		velocity.y = -jump_force * jump_mult * mod
		_jump_buffer_timer = 0
		_coyote_timer = 0

## fungsi buatan sendiri yang mengatur animasi player
func _animation() -> void:
	if is_on_floor():
		if _direction != 0:
			animation.play("Move")
		else:
			animation.play("Idle")
	else:
		if velocity.y > 0:
			animation.play("Fall")
		elif velocity.y < 0:
			animation.play("Jump")
	
	_facing_direction()

## fungsi buatan sendiri yang mengatur tatapn animasi karakter
func _facing_direction() -> void:
	if _direction > 0:
		animation.flip_h = false
	elif _direction < 0:
		animation.flip_h = true

## Bagian ini untuk Testing/Demo Tugas UKM
func _unhandled_input(event: InputEvent) -> void:
	# Toggle Instan (Key 1, 2, 3)
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				current_weight = 0.0
				_print_demo_status("Normal (0kg)")
			KEY_2:
				current_weight = max_weight * 0.5
				_print_demo_status("Medium (50kg)")
			KEY_3:
				current_weight = max_weight
				_print_demo_status("Overload (100kg)")

# Fungsi pembantu agar terlihat rapi di Output/Console
func _print_demo_status(status: String) -> void:
	print("--- DEMO MEKANIK ---")
	print("Status Beban: ", status)
	print("Current Weight: ", current_weight)
	print("Speed Modifier: ", 1.0 - (current_weight / max_weight * weight_penalty_factor))
