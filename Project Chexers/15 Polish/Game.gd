extends Node

var isPlayer1 : bool = true
var isMouseFree : bool = true
var changeTurnTimer = 0

var player1Pieces = []
var player2Pieces = []

var hex1Color : Color = Color('#C26100')
var hex2Color : Color = Color('#128FB5')
var player1Color : Color = Color('#BF2E26')
var player2Color : Color = Color('#212B33')

func _ready():
	#SignalBus.connect("NextTurn", self, "_onNextTurn")
	pass
	
func _process(delta):
	if(changeTurnTimer > 0):
		changeTurnTimer -= delta
		if(changeTurnTimer <= 0):
			SignalBus.emit_signal("NextTurn")
			isMouseFree = true
			
	
func startNextTurn():
	if(player1Pieces.size() == 0):
		SignalBus.emit_signal("PlayerWins", false)	
	elif(player2Pieces.size() == 0):
		SignalBus.emit_signal("PlayerWins", true)
	else:
		isPlayer1 = !isPlayer1
		changeTurnTimer = 1
		isMouseFree = false

func startNewGame():
	isPlayer1 = player1Pieces.size() == 0
	for piece in (player1Pieces + player2Pieces):
		piece.queue_free()
	player1Pieces = []
	player2Pieces = []
	SignalBus.emit_signal("NextTurn")
	SignalBus.emit_signal("StartNewGame")
