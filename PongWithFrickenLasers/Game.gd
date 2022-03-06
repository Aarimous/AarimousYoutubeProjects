extends Node2D

var player1Score = 0
var player2Score = 0

#connected tot he Player1GoalArea2D signal
func _on_Player1GoalArea2D_body_entered(body):
	if(body is Ball):
		$Ball.resetBall(-1)
		player2Score += 1
		$Player2Score.text = str(player2Score)

#connected tot he Player1GoalArea2D signal
func _on_Player2GoalArea2D_body_entered(body):
	if(body is Ball):
		$Ball.resetBall(1)
		player1Score += 1
		$Player1Score.text = str(player1Score)

