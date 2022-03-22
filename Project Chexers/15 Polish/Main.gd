extends Spatial

var _paused : bool = false

func _input(event):
	if(Input.is_action_just_pressed("pauseGame")):
		_paused = !_paused
		$CanvasLayer/PauseScreen.visible = _paused
	pause_mode = true
