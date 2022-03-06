extends KinematicBody2D
#used so we can deterime what type the object is for collisions
class_name Ball


onready var startPos = position

var direction = Vector2(-1,0)
var speed = 300
var speedStep = 50
var startTimer = 2

#called when a ball is scored
func resetBall(startDirection : int):
	position = startPos
	speed = 300
	startTimer = 2
	direction = Vector2(startDirection, 0)

#runs each frame
func _process(delta):
	
	#a breif cooldown between each volley
	if(startTimer > 0):
		startTimer -= delta
	else:
		var velocity = speed * direction * delta
		var collisionObj : KinematicCollision2D = move_and_collide(velocity)
		if collisionObj:
			direction = direction.bounce(collisionObj.normal)
			#only speed the ball up with we collided with a player
			if(collisionObj.collider is Player):
				speed += speedStep
				#imparts "spin" on the direction if the player was moving
				direction = (direction + Vector2(0, collisionObj.collider.moveDirection * 0.5)).normalized()
		
