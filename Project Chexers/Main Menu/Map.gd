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
var _player1SuperRows = [0]
var _player2Rows = [0,1]
var _player2SuperRows = [6]
var _selectedCell : Vector2
var _captureCell 


func _ready():
	_hexUtil = HexagonUtility.new(_cellSize)
	_generateHexTileMap()
	SignalBus.connect("HighlightMoveableTiles",self, "_onHighlightMoveableTiles")
	SignalBus.connect("MovePieceToNewCell", self, "_onMovePieceToNewCell")
	SignalBus.connect("CaptureTile", self, "_onCaptureTile")
	
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
		_addNewPieceToHex(cell, true)
	if(cell.y in _player2Rows):
		_addNewPieceToHex(cell, false)

	
func _addCellToAStar(cell : Vector2, id : int):
	AStarCells.add_point(id, cell, 1.0)
	for neighborVector in _neighborVectors:
		if(TilesDict.has(cell + neighborVector)):
			AStarCells.connect_points(id, AStarCells.get_closest_point(cell + neighborVector))	
	
	
func _addNewPieceToHex(cell : Vector2, isPlayer1 : bool):
	if(TilesDict.has(cell) == false):
		push_warning(str("Warning: In Map._addNewPieceToHex Cell:", cell, " is not a valid Hex Cell"))
		return
	var piece = _piecePackedScene.instance().init(isPlayer1)
	TilesDict[cell].addPiece(piece)


func _getAdjacentTile(cell : Vector2):
	var returnTiles = []
	var neighborIds = AStarCells.get_point_connections(AStarCells.get_closest_point(cell))
	for neighborId in neighborIds:
		var neighborCell = AStarCells.get_point_position(neighborId)
		returnTiles.append(TilesDict[neighborCell])
	return returnTiles

func _onHighlightMoveableTiles(cell : Vector2, piece : Piece):
	_unHighlightCell()
	_selectedCell = cell
	_highlightedCell.append(cell)
	_highlightTiles(cell, true, true, piece.getIsPlayer1(), piece.getIsSuper())

			
func _highlightTiles(cell: Vector2, moveable : bool, capturable: bool, isPlayer1 : bool, isSuper: bool):
	for neighborTile in _getAdjacentTile(cell):
		if(isSuper == false):
			if (isPlayer1 and neighborTile.cell.y > cell.y) or (isPlayer1 == false and neighborTile.cell.y < cell.y):
				continue
		if(moveable and neighborTile.hasPiece() == false):
			neighborTile.highlight()
			_highlightedCell.append(neighborTile.cell)
		if(capturable and _isValidCaptureTile(neighborTile, isPlayer1, isSuper)):
			neighborTile.highlightCapture()
			_highlightedCell.append(neighborTile.cell)


func _onCaptureTile(cell : Vector2):
	var piece = TilesDict[_selectedCell].getPiece()
	_unHighlightCell()
	_highlightTiles(cell, true, false, piece.getIsPlayer1(), piece.getIsSuper())
	_captureCell = cell
		
		
func _isValidCaptureTile(tile, isPlayer1 : bool, isSuper : bool) -> bool:
	if(tile.hasPiece() == false):
		return false
	if(tile.getPiece().getIsPlayer1() == Game.isPlayer1):
		return false
	for neighborTile in _getAdjacentTile(tile.cell):
		if(isSuper == false):
			if (isPlayer1 and neighborTile.cell.y > tile.cell.y) or (isPlayer1 == false and neighborTile.cell.y < tile.cell.y):
				continue
		if(neighborTile.hasPiece() == false):
			return true
	return false


func _onMovePieceToNewCell(cell : Vector2):
	var piece = TilesDict[_selectedCell].getPiece()
	TilesDict[cell].addPiece(piece)
	_unHighlightCell()
	_checkIfSuperPromotion(cell, piece)
	if(_captureCell):
		TilesDict[_captureCell].getPiece().free()
		_captureCell = null
		_highlightTiles(cell, false, true, piece.getIsPlayer1(), piece.getIsSuper())
	if(_highlightedCell.empty()):
		SignalBus.emit_signal("NextTurn")
	else:
		_selectedCell = cell
		
func _checkIfSuperPromotion(cell, piece):
	if(piece.getIsPlayer1() and cell.y in _player1SuperRows):
		piece.promoteToSuper()
	if(piece.getIsPlayer1() == false and cell.y in _player2SuperRows):
		piece.promoteToSuper()
	
	

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
