extends Spatial

export var _cellSize : Vector2 = Vector2(1,1)
export var _mapSize : Vector2 = Vector2(5,10)
export var _hexagonTilePackedScene : PackedScene
export var _piecePackedScene : PackedScene

var TilesDict : Dictionary = {}
var AStarCells = AStar2D.new()

var _hexUtil : HexagonUtility
var _highlightedCell = []
var _neighborVectors = [Vector2(0,-1), Vector2(1,-1), Vector2(-1,0),Vector2(1,0) ,Vector2(-1,1) ,Vector2(0,1)]
var _player1Rows = [5,6]
var _player2Rows = [0,1]
var _selectedCell : Vector2


func _ready():
	_hexUtil = HexagonUtility.new(_cellSize)
	_generateHexTileMap()
	SignalBus.connect("HighlightMoveableTiles",self, "_onHighlightMoveableTiles")
	SignalBus.connect("MovePieceToNewCell", self, "_onMovePieceToNewCell")
	
func _generateHexTileMap():
	var id = 0
	for cell in _getCellsToCreate():
		_addNewHexTile(cell, id)
		id += 1
		
		
func _addNewHexTile(cell : Vector2, id : int):
	var color =  Color('#1e272e') if int(cell.y) % 2 == 0 else Color('#ff3f34')
	var hexTile = _hexagonTilePackedScene.instance().init(cell, color)
	var tilePosition =  _hexUtil.CellToPixel(cell)
	hexTile.translation = Vector3(tilePosition.x, 0, tilePosition.y)
	add_child(hexTile)
	TilesDict[cell] = hexTile
	_addCellToAStar(cell, id)
	if(cell.y in _player1Rows):
		_addNewPieceToHex(cell)
	if(cell.y in _player2Rows):
		_addNewPieceToHex(cell)

	
func _addCellToAStar(cell : Vector2, id : int):
	AStarCells.add_point(id, cell, 1.0)
	for neighborVector in _neighborVectors:
		if(TilesDict.has(cell + neighborVector)):
			AStarCells.connect_points(id, AStarCells.get_closest_point(cell + neighborVector))	
	
	
func _addNewPieceToHex(cell : Vector2):
	if(TilesDict.has(cell) == false):
		push_warning(str("Warning: In Map._addNewPieceToHex Cell:", cell, " is not a valid Hex Cell"))
		return
	var piece = _piecePackedScene.instance()
	TilesDict[cell].addPiece(piece)



func _onHighlightMoveableTiles(cell : Vector2):
	_unHighlightCell()
	
	_selectedCell = cell
	_highlightedCell.append(cell)
	
	var neighborIds = AStarCells.get_point_connections(AStarCells.get_closest_point(cell))
	for neighborId in neighborIds:
		var neighborCell = AStarCells.get_point_position(neighborId)
		if(TilesDict[neighborCell].hasPiece() == false):
			TilesDict[neighborCell].highlight()
			_highlightedCell.append(neighborCell)


func _onMovePieceToNewCell(cell : Vector2):
	TilesDict[cell].addPiece(TilesDict[_selectedCell].getPiece())
	_unHighlightCell()

func _unHighlightCell():
	for highlightedCell in _highlightedCell:
		TilesDict[highlightedCell].unHighlight()
	_highlightedCell = []	

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
