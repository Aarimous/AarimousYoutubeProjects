extends Spatial

var _isPlayer1 : bool

func init(isPlayer1 : bool):
	self._isPlayer1 = isPlayer1
	if(isPlayer1):
		_setupMaterial(Game.player1Color)
	else:
		_setupMaterial(Game.player2Color)
	return self
	
func _setupMaterial(var color : Color):
	var spatialMat = SpatialMaterial.new()
	spatialMat.albedo_color = color
	$Cylinder.set_surface_material(0,spatialMat)
	
func getIsPlayer1():
	return _isPlayer1
