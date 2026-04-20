extends Node2D

@onready var area_checker: AreaChecker2D = $AreaChecker2D
@onready var sprite: Sprite2D = $Sprite2D

# Kamu bisa memasukkan beberapa platform ke sini melalui Inspector
@export var target_platforms: Array[MovingPlatform2D] = []

var lever_on: bool = false

func _input(event: InputEvent) -> void:
	# Cek apakah player di area DAN menekan tombol interaksi (misal: 'E')
	if area_checker.is_body_enter_area() and event.is_action_pressed("interact"):
		toggle_lever()

func toggle_lever() -> void:
	lever_on = !lever_on
	
	# Ubah visual tuas (opsional)
	sprite.flip_h = lever_on 
	
	# Gerakkan semua platform yang terhubung
	for platform in target_platforms:
		if platform: # Pastikan platform tidak kosong
			platform.toggle_platform(lever_on)
	
	print("Lever toggled: ", lever_on)
