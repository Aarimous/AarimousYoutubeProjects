extends Node

var isPlayer1 : bool = true

#var hex1Color : Color = Color('#1e272e')
#var hex2Color : Color = Color('#ff3f34')
#var player1Color : Color = Color.darkcyan
#var player2Color : Color = Color.darkgoldenrod

var hex1Color : Color = Color('#C26100')
var hex2Color : Color = Color('#128FB5')
var player1Color : Color = Color('#BF2E26')
var player2Color : Color = Color('#212B33')

func _ready():
	SignalBus.connect("NextTurn", self, "_onNextTurn")
	
func _onNextTurn():
	isPlayer1 = !isPlayer1

