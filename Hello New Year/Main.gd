extends Node2D

export (PackedScene) var fireworkPacked

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				var firework = fireworkPacked.instance()
				add_child(firework)
				firework.position = event.position
