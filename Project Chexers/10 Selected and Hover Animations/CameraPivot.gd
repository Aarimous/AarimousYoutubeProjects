extends Spatial


func _ready():
	SignalBus.connect("NextTurn", self, "_onNextTurn")


func _onNextTurn():
	rotate(Vector3.UP, deg2rad(180.0))
