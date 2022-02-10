extends Node

var isPlayer1 : bool = true

var player1Color : Color = Color.darkcyan
var player2Color : Color = Color.darkgoldenrod

func _ready():
	SignalBus.connect("NextTurn", self, "_onNextTurn")
	
func _onNextTurn():
	isPlayer1 = !isPlayer1
