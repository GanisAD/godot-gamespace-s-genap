class_name ProjectileSpawner2D
extends Node

## digunakan untuk mengeluarkan projectile saat player menekan input
##
## variabel yang dibutuhkan [br]
## -> marker [br]
## -> player [br]
## -> projectile scene [br]

#@export var array_scene: Array[PackedScene] = []
@export var player: Player2D = null
@export var marker: Marker2D = null
@export var projectile_scene: PackedScene = null
@export var titik_spawn: Node2D = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		spawn_projectile()

func spawn_projectile() -> void:
	
	# butuh scene kemudian di instance
	# setup beberapa kebutuhan dari scene 
	# tambahkan ke scene tree lewat fungsi add child
	
	#var _projectile_e = Projectile2D.new()
	
	var projectile = projectile_scene.instantiate() as Projectile2D
	#var projectile = Projectile2D.new()
	var projectile_dir = 1 if player.get_direction() > 0 else -1
	projectile.set_projectile_speed(player.projectile_speed * projectile_dir)
	projectile.set_projectile_damage(player.projectile_damage)
	player.projectile_container.add_child(projectile)
	projectile.global_position = marker.global_position
	#projectile.global_position = titik_spawn.global_position

func adjust_marker_pos() -> void:
	if player.get_direction() > 0:
		marker.position.x = 50
	elif player.get_direction() < 0:
		marker.position.x = -50
	#print("marker pos x : " + str(marker.position))

func _process(_delta: float) -> void:
	adjust_marker_pos()
