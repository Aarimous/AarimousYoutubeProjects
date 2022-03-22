extends Control


func _ready():
	SignalBus.connect("NextTurn",self, "_onNextTurn")
	SignalBus.connect("UpdatePlayerScore",self, "_onUpdatePlayerScore")
	$Player1Score.add_color_override("font_color", Game.player1Color)
	$Player2Score.add_color_override("font_color", Game.player2Color)
	_onNextTurn()
	
func _onUpdatePlayerScore():
	$Player1Score.text = str(Game.player1Pieces.size())
	$Player2Score.text = str(Game.player2Pieces.size())


func _onNextTurn():
	if(Game.isPlayer1):
		$PlayerTurnLabel.text = "Player 1"
		$PlayerTurnLabel.add_color_override("font_color", Game.player1Color)
	else:
		$PlayerTurnLabel.text = "Player 2"
		$PlayerTurnLabel.add_color_override("font_color", Game.player2Color)
