class_name Player2D
extends CharacterBody2D
## Player Class
##
## Player class digunakan untuk mengontrol semua pergerakan dari player. Mulai dari jump, move, dll.
@export var animation: AnimatedSprite2D = null

@export_group("Health")
@export var max_health: float = 100

@export_group("Projectile Data")
@export var projectile_speed: float = 0
@export var projectile_damage: float = 0
@export var projectile_container: Node2D = null

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

var _direction: float = 0
var _coyote_timer: float = 0
var _jump_buffer_timer: float = 0
var _last_direction: float = 0
var _current_health: float = 0

func _ready() -> void:
	_current_health = max_health

func get_current_health() -> float:
	return _current_health

func get_max_health() -> float:
	return max_health

func get_direction() -> float:
	return _last_direction

## Fungsi Process ini digunakan untuk memproses game secara terus menerus tanpa henti
## sampai game dihentikan
func _process(_delta: float) -> void:
	_animation()

## Fungsi Physics Process digunakan untuk memproses game secara terus menerus juga, namun di fungsi ini
## ada tambahan proses fisika (Grivtasi, Velocity, dll)
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_mult
		_coyote_timer -= delta
	else:
		_coyote_timer = coyote_time
	
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer
	
	_jump_buffer_timer -= delta
	
	_jump()
	_move()
	move_and_slide() ## (PENTING !!) fungsi untuk meng eksekusi proses fisika

## fungsi buatan sendiri yang mengatur move
func _move() -> void:
	_direction = Input.get_axis("left", "right")
	if _direction != 0:
		# velocity itu hasil kali dari arah dan kecepatan
		_last_direction = _direction
		velocity.x = move_toward(velocity.x, move_speed * _direction * speed_mult, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

## fungsi buatan sendiri yang mengatur jump
func _jump() -> void:
	if _jump_buffer_timer > 0 and _coyote_timer > 0:
		velocity.y = -jump_force * jump_mult
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
