extends Button
class_name replayButton

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/startScreen/root/startScreen.tscn")
