extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var checker: AreaChecker2D = $AreaChecker2D

@export var active_texture: Texture2D # Masukkan gambar bendera aktif di Inspector
@export var inactive_texture: Texture2D # Masukkan gambar bendera mati di Inspector

var is_activated: bool = false

func _ready() -> void:
	# Berikan tampilan awal
	sprite.texture = inactive_texture
	
	# Hubungkan sinyal dari anak (AreaChecker2D) ke fungsi di sini
	checker.body_entered.connect(_on_player_detected)

func _on_player_detected(body: Node2D) -> void:
	# Cek apakah yang masuk benar-benar grup yang diinginkan
	if body.is_in_group(checker.group_name) and not is_activated:
		activate_checkpoint()

func activate_checkpoint() -> void:
	is_activated = true
	sprite.texture = active_texture # Ganti gambar jadi aktif
	
	# Simpan posisi global Node2D ini ke GameManager
	GameManager.update_checkpoint(global_position)
	
	print("Checkpoint berhasil diambil!")
