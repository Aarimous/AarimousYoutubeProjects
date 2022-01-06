extends Spatial

#For 2D games this will be the hight/width of your hexagon sprite
export var _cellSize : Vector2 = Vector2(1,1)
export var _mapSize : Vector2 = Vector2(5,10)
export var _hexagonTilePackedScene : PackedScene

var hexUtil : HexagonUtility

func _ready():
	hexUtil = HexagonUtility.new(_cellSize)
	_generateHexTileMap()
	
func _generateHexTileMap():
	for cell in _getCellsToCreate():
		var color =  Color('#1e272e') if int(cell.y) % 2 == 0 else Color('#ff3f34')
		var hexTile = _hexagonTilePackedScene.instance().init(cell, color)
		var tilePosition =  hexUtil.CellToPixel(cell)
		hexTile.translation = Vector3(tilePosition.x, 0, tilePosition.y)
		add_child(hexTile)
			

func _getCellsToCreate():
	var cellsToCreate = []
	cellsToCreate.append(Vector2(-2,0))
	cellsToCreate.append(Vector2(-1,0))
	cellsToCreate.append(Vector2(0,0))
	cellsToCreate.append(Vector2(1,0))
	cellsToCreate.append(Vector2(2,0))
	
	cellsToCreate.append(Vector2(-2,1))
	cellsToCreate.append(Vector2(-1,1))
	cellsToCreate.append(Vector2(0,1))
	cellsToCreate.append(Vector2(1,1))
	
	cellsToCreate.append(Vector2(-3,2))
	cellsToCreate.append(Vector2(-2,2))
	cellsToCreate.append(Vector2(1,2))
	cellsToCreate.append(Vector2(0,2))
	cellsToCreate.append(Vector2(-1,2))
	
	cellsToCreate.append(Vector2(-4,3))
	cellsToCreate.append(Vector2(-3,3))
	cellsToCreate.append(Vector2(-2,3))
	cellsToCreate.append(Vector2(1,3))
	cellsToCreate.append(Vector2(0,3))
	cellsToCreate.append(Vector2(-1,3))

	cellsToCreate.append(Vector2(-4,4))
	cellsToCreate.append(Vector2(-3,4))
	cellsToCreate.append(Vector2(-2,4))
	cellsToCreate.append(Vector2(-1,4))
	cellsToCreate.append(Vector2(0,4))

	cellsToCreate.append(Vector2(-4,5))
	cellsToCreate.append(Vector2(-3,5))
	cellsToCreate.append(Vector2(-2,5))
	cellsToCreate.append(Vector2(-1,5))

	cellsToCreate.append(Vector2(-5,6))
	cellsToCreate.append(Vector2(-4,6))
	cellsToCreate.append(Vector2(-3,6))
	cellsToCreate.append(Vector2(-2,6))
	cellsToCreate.append(Vector2(-1,6))
	
	return cellsToCreate
