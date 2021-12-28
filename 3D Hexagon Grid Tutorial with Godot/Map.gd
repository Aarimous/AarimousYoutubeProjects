extends Spatial

#For 2D games this will be the hight/width of your hexagon sprite
export var _cellSize : Vector2 = Vector2(1,1)
export var _mapSize : Vector2 = Vector2(5,10)
export var _hexagonTilePackedScene : PackedScene

func _ready():
	_generateHexTileMap()
	
			
func _generateHexTileMap():
	for x in range(-10,_mapSize.x):
		for y in range(-_mapSize.y,5):
			var hexTile = _hexagonTilePackedScene.instance()
			var cell = Vector2(x,y)
			var tilePosition =  _cellToPixel(cell)
			#For 2D games use hexTile.position = tilePosition
			hexTile.translation = Vector3(tilePosition.x, 0, tilePosition.y)
			add_child(hexTile)
			
			
func _cellToPixel(cell : Vector2) -> Vector2:
	var x = (sqrt(3.0) * cell.x + sqrt(3.0) / 2.0 * cell.y) * _cellSize.x;
	var y = (0.0 * cell.x + 3.0 / 2.0 * cell.y) * _cellSize.y
	return Vector2(x, y)
			
