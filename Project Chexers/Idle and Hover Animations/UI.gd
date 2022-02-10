extends Control


func _ready():
	SignalBus.connect("NextTurn",self, "_onNextTurn")
	_onNextTurn()


func _onNextTurn():
	if(Game.isPlayer1):
		$PlayerTurnLabel.text = "Player 1"
		$PlayerTurnLabel.add_color_override("font_color", Game.player1Color)
	else:
		$PlayerTurnLabel.text = "Player 2"
		$PlayerTurnLabel.add_color_override("font_color", Game.player2Color)
