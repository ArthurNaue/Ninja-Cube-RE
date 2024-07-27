extends Button
class_name PlayButton

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1/root/level1.tscn")
