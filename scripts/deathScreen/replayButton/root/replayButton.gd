extends Button
class_name replayButton

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/level1/root/level1.tscn")
