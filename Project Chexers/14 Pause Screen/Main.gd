extends Spatial

var _paused : bool = false

func _input(event):
	if(Input.is_action_just_pressed("pauseGame")):
		_paused = !_paused
		$CanvasLayer/PauseScreen.visible = _paused
		
		#use to stop process functions from running
		#pause_mode = _paused
