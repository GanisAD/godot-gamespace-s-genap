extends Node

# Simpan posisi respawn terakhir di sini
var last_checkpoint_pos: Vector2 = Vector2.ZERO

func update_checkpoint(new_pos: Vector2) -> void:
	last_checkpoint_pos = new_pos
	print("Checkpoint diperbarui ke: ", last_checkpoint_pos)
