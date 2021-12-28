extends Spatial

var cell : Vector2

func init(var cell : Vector2, var color : Color):
	self.cell = cell
	self.name = str(self.cell)
	_setupMaterial(color)
	return self
	

func _setupMaterial(var color : Color):
	var spatialMat = SpatialMaterial.new()
	spatialMat.albedo_color = color
	$Cylinder.set_surface_material(0,spatialMat)
