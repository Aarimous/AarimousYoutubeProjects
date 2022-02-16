class_name HexagonUtility

var _cellSize : Vector2

var _sqrt3
var _sqrt3over2
var _3over2

func _init(cellSize : Vector2):
	self._cellSize = cellSize
	self._sqrt3 = sqrt(3.0)
	self._sqrt3over2 = _sqrt3/2.0
	self._3over2 = 3.0/2.0
	
			
func CellToPixel(cell : Vector2) -> Vector2:
	var x = (_sqrt3 * cell.x + _sqrt3over2 * cell.y) * _cellSize.x;
	var y = (0.0 * cell.x + _3over2 * cell.y) * _cellSize.y
	return Vector2(x, y)
			
