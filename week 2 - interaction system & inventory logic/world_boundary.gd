extends Node2D

@export var area_checker: AreaChecker2D

func _ready() -> void:
	area_checker.body_entered.connect(_on_void_entered)

func _on_void_entered(body: Node2D) -> void:
	if body.is_in_group(area_checker.group_name):
		# Jika GameManager belum punya data checkpoint, gunakan posisi awal
		var spawn_pos = GameManager.last_checkpoint_pos
		
		if spawn_pos == Vector2.ZERO:
			print("Peringatan: Belum ada checkpoint, player mungkin hilang!")
		else:
			body.global_position = spawn_pos
			
			if body is CharacterBody2D:
				body.velocity = Vector2.ZERO
			
			print("Player respawn di checkpoint.")
