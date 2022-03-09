extends Spatial
class_name Piece

var _isPlayer1 : bool
var _isSuper : bool
var _gettingCaptured = false
var _newHexTile
var _tweenDuration = 0.5
var _hasVerticalTweenRanTwice : bool = false

export var onSelectMP3 : AudioStreamMP3
export var onCaptureMP3 : AudioStreamMP3

func init(isPlayer1 : bool):
	self._isPlayer1 = isPlayer1
	self._isSuper = false
	if(isPlayer1):
		_setupMaterial(Game.player1Color)
	else:
		_setupMaterial(Game.player2Color)
	return self
	
func _setupMaterial(var color : Color):
	var spatialMat = SpatialMaterial.new()
	spatialMat.albedo_color = color
	$Cylinder.set_surface_material(0,spatialMat)
	
	
func toggleSelected(select : bool):
	$AnimationTree["parameters/conditions/selected"] = select
	$AnimationTree["parameters/conditions/idle"] = !select
	if(select):
		$AudioStreamPlayer3D.stream = onSelectMP3
		$AudioStreamPlayer3D.play()
	
func getIsPlayer1():
	return _isPlayer1
	
func getIsSuper():
	return _isSuper
	
func promoteToSuper():
	self._isSuper = true
	
func getCaptured():
	_gettingCaptured = true
	$AudioStreamPlayer3D.stream = onCaptureMP3
	$AudioStreamPlayer3D.play()
	
	
func _on_AudioStreamPlayer3D_finished():
	if(_gettingCaptured):
		queue_free()
		
		
func moveToNewHexagonTile(newHexagonTile):
	_newHexTile = newHexagonTile 
	_hasVerticalTweenRanTwice = false
	tweenHorizontally(to_local(newHexagonTile.getSlotPos()))
	tweenVertically(1, Tween.EASE_OUT)


func tweenHorizontally(toPos : Vector3):
	$TweenHorizontal.interpolate_property(self, "translation:x", null, toPos.x, _tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenHorizontal.interpolate_property(self, "translation:z", null, toPos.z,_tweenDuration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenHorizontal.start()
	
	
func tweenVertically(y : float, easeType):
	$TweenVertical.interpolate_property(self, "translation:y", null, y, 0.25, Tween.TRANS_LINEAR, easeType)
	$TweenVertical.start()


func _on_TweenHorizontal_tween_completed(object, key):
	_newHexTile.addPiece(self)


func _on_TweenVertical_tween_completed(object, key):
	if(_hasVerticalTweenRanTwice == false):
		_hasVerticalTweenRanTwice = true
		tweenVertically(0, Tween.EASE_IN)
