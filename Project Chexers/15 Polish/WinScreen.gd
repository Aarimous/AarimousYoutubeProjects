extends Control

func _ready():
	visible = false
	SignalBus.connect("PlayerWins",self, "_onPlayerWins")
	
func _onPlayerWins(isPlayer1 : bool):
	visible = true
	$CPUParticles2D.restart()
	$AudioStreamPlayer.play()
	if(isPlayer1):
		$MarginContainer/VBoxContainer/Player.text = "Player1"
		#$MarginContainer/VBoxContainer/Player.add_color_override("font_color", Game.player1Color)
	else:
		$MarginContainer/VBoxContainer/Player.text = "Player2"
		#$MarginContainer/VBoxContainer/Player.add_color_override("font_color", Game.player2Color)


func _on_NewGame_button_up():
	Game.startNewGame()
	visible = false
	$AudioStreamPlayer.stop()
