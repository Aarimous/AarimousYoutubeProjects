extends Spatial

var cell : Vector2
var _color : Color
var _isHighlighted = false
var _isHighlightedCapture = false

func init(var cell : Vector2, var color : Color):
	self.cell = cell
	self._color = color
	self.name = str(self.cell)
	_setupMaterial(color)
	return self
	
func highlight():
	$Cylinder.get_surface_material(0).albedo_color = Color.green
	_isHighlighted = true
	
func highlightCapture():
	$Cylinder.get_surface_material(0).albedo_color = Color.pink
	_isHighlightedCapture = true
	
func unHighlight():
	$Cylinder.get_surface_material(0).albedo_color =  _color
	_isHighlighted = false
	if(hasPiece()):
		getPiece().toggleSelected(false)

func _setupMaterial(var color : Color):
	var spatialMat = SpatialMaterial.new()
	spatialMat.albedo_color = color
	$Cylinder.set_surface_material(0,spatialMat)
	
func addPiece(var piece):
	if(piece.get_parent()):
		piece.get_parent().remove_child(piece)
	$Cylinder/Slot.add_child(piece)

func hasPiece() -> bool:
	return $Cylinder/Slot.get_child_count() > 0
	
func getPiece():
	return $Cylinder/Slot.get_child(0)

func _on_StaticBody_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				if hasPiece() and getPiece().getIsPlayer1() == Game.isPlayer1:
					$Cylinder.get_surface_material(0).albedo_color = Color.yellow
					SignalBus.emit_signal("HighlightMoveableTiles", self.cell, getPiece())
					getPiece().toggleSelected(true)
				elif _isHighlighted:
					SignalBus.emit_signal("MovePieceToNewCell", self.cell)
				elif _isHighlightedCapture:
					SignalBus.emit_signal("CaptureTile", self.cell)


func _on_StaticBody_mouse_entered():
	$AnimationPlayer.play("OnHover")
	$AudioStreamPlayer3D.play()
