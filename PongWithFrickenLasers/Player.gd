extends KinematicBody2D
#used to check if a collison is a player
class_name Player

var moveDirection = 0
var moveSpeed = 1000
var compMoveThreshold = 50
var ball
var compFireTimer = 1
var stunTimer = 0

export var laserPackedScene : PackedScene
export var isHuman = true

#called when the scene loads
func _ready():
	ball = get_parent().get_node("Ball")
	
#runs each frame
func _process(delta):
	#if scene is stunned, should reduce the stun Time
	if(stunTimer > 0):
		stunTimer -= delta
	#only runs this if scene is not stunned
	else:
		#code from none human players
		if(isHuman == false):
			setMoveDirectionForComputer()
			compFireTimer -= delta
			if(compFireTimer < 0):
				fireAndReloadLaserForComp()
		#for human players
		else:
			if(Input.is_action_just_pressed("fireTheLaser")):
				#create a laser and setup the key parts
				var newLaser = laserPackedScene.instance()
				get_parent().add_child(newLaser)
				newLaser.position = $LaserStartPoint.global_position
				newLaser.fireTheLaser(Vector2(1,0), Color.blue)
		
		#move the paddle using move_and_collide, in this case we don't care about what we collide with
		var velocity = Vector2(0, moveDirection * moveSpeed * delta)
		move_and_collide(velocity)
	
func _input(event):
	#only update moveDirection if we are a human
	if(isHuman):
		#See actions by going to Project > Projet settings > Input Map
		moveDirection = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

func stun():
	stunTimer = 1.0

#used to fire the laser for non human player and then reset the timer
func fireAndReloadLaserForComp():
	var newLaser = laserPackedScene.instance()
	get_parent().add_child(newLaser)
	newLaser.position = $LaserStartPoint.global_position
	newLaser.fireTheLaser(Vector2(-1,0), Color.red)
	#random timer between 1 and 2
	compFireTimer = rand_range(1,2)
	
#ran to figure out which way the computer should move based on the ball's y value
func setMoveDirectionForComputer():
	moveDirection = 0
	if(abs(position.y - ball.position.y) > compMoveThreshold):
		if(position.y > ball.position.y):
			moveDirection = -1
		elif(position.y < ball.position.y):
			moveDirection = 1
