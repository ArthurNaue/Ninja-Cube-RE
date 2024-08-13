extends RichTextLabel

func _ready() -> void:
	text = "[center]" + str(GameManager.bestScore)
