extends Node2D

var pawn = preload("res://Resources/ChessPieces/pawn.svg")
var rook = preload("res://Resources/ChessPieces/rook.svg")
var knight = preload("res://Resources/ChessPieces/knight.svg")
var bishop = preload("res://Resources/ChessPieces/bishop.svg")
var king = preload("res://Resources/ChessPieces/king.svg")
var queen = preload("res://Resources/ChessPieces/queen.svg")

## Places a chess piece on the chessboard on the node with node_name (i.e A1, B5)
## and applies the texture to the chesspiece
func place_piece(chessboard: Node, node_name: String, texture: Resource) -> void:
	var node = chessboard.get_node(node_name)
	var sprite = Sprite.new()
	var sprite_x = node.get_position().x + node.get_size().x / 2
	var sprite_y = node.get_position().y + node.get_size().y / 2
	sprite.set_position(Vector2(sprite_x, sprite_y))
	sprite.texture = texture
	sprite.set_scale(Vector2(0.433, 0.433))
	chessboard.add_child(sprite)

# Called when the node enters the scene tree for the first time.
func _ready():
	var chessboard = get_node("Panel/Chessboard")
	var white_pawn_nodes = ["A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2"]
	var white_rook_nodes = ["A1", "H1"]
	var white_knight_nodes = ["B1", "G1"]
	var white_bishop_nodes = ["C1", "F1"]

	for node_name in white_pawn_nodes:
		place_piece(chessboard, node_name, pawn)
	
	for node_name in white_rook_nodes:
		place_piece(chessboard, node_name, rook)
		
	for node_name in white_knight_nodes:
		place_piece(chessboard, node_name, knight)
	
	for node_name in white_bishop_nodes:
		place_piece(chessboard, node_name, bishop)
	
	place_piece(chessboard, "D1", queen)
	place_piece(chessboard, "E1", king)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
