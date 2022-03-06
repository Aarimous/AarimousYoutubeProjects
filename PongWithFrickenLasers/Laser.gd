extends KinematicBody2D

var speed = 1000
var direction

export var newColor : Color


#used when we create the laser to give it a direction and color
func fireTheLaser(directionVec : Vector2, laserColor : Color):
	direction = directionVec
	$ColorRect.color = laserColor
	
#runs each frame so we can move the laser and see if it collided with anything in is collision mask
func _process(delta):
	var collisonObj = move_and_collide(direction * speed * delta)
	if(collisonObj):
		#only call stun if we collided with a Player
		if(collisonObj.collider is Player):
			collisonObj.collider.stun()
		#removes the last 
		queue_free()
