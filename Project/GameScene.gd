extends Node2D

var chosen_piece
signal square_pos(pos)
#signal move_piece(piece_name, target_pos)

var pawn = preload("res://Resources/ChessPieces/pawn.svg")
var rook = preload("res://Resources/ChessPieces/rook.svg")
var knight = preload("res://Resources/ChessPieces/knight.svg")
var bishop = preload("res://Resources/ChessPieces/bishop.svg")
var king = preload("res://Resources/ChessPieces/king.svg")
var queen = preload("res://Resources/ChessPieces/queen.svg")

var red_pawn = preload("res://Resources/ChessPieces/pawn_red.svg")
var red_rook = preload("res://Resources/ChessPieces/rook_red.svg")
var red_knight = preload("res://Resources/ChessPieces/knight_red.svg")
var red_bishop = preload("res://Resources/ChessPieces/bishop_red.svg")
var red_king = preload("res://Resources/ChessPieces/king_red.svg")
var red_queen = preload("res://Resources/ChessPieces/queen_red.svg")

## Places a chess piece on the chessboard on the node with node_name (i.e A1, B5)
## and applies the texture to the chesspiece
func place_piece(chessboard: Node, node_name: String, texture: Resource, piece_name: String) -> void:
	var chessboard_square = chessboard.get_node(node_name)
	
	# Get the color rectangle for the square
	var color_rect_name = node_name + "_rect"
	var color_rect = chessboard_square.get_node(color_rect_name)
	
	# Create Area2D that will contain the piece
	var area2d = Area2D.new()
	area2d.set_script(load("res://Piece_logic.gd"))
	area2d.name = piece_name # set name of the piece to the pieces name
	area2d.input_pickable = true # Make piece clickable
	
	var area2d_x = chessboard_square.get_position().x
	var area2d_y = chessboard_square.get_position().y
	area2d.set_position(Vector2(area2d_x, area2d_y))
	
	var sprite = Sprite.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.set_scale(Vector2(0.433, 0.433))
	
	var collisionShape = _create_collisionshape(color_rect, area2d_x, area2d_y)
	
	# Add Tween for movement animation
	var tween = Tween.new()
	tween.name = "Tween"
	
	area2d.add_child(collisionShape)
	area2d.add_child(sprite)
	area2d.add_child(tween)
	chessboard.add_child(area2d)

## Create a collisonshape for a piece where the mouse clicks will be identified
func _create_collisionshape(node: Node, sprite_x:float, sprite_y:float)->CollisionShape2D:
	var collisionShape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	# set position and extents to half the square size since the origin of the
	# shape is in the center
	var shape_size = node.get_size()/2
	shape.set_extents(shape_size)
	collisionShape.position = shape_size
	
	collisionShape.set_shape(shape)
	return collisionShape

func _chosen_piece(piece):
	chosen_piece = piece
	print("chosen piece ", chosen_piece.name)
	var H6 = get_node("Panel/Chessboard/H6").set_pickable(true)

func _send_position(square):
	print("send pos " + square.name)
	if chosen_piece != null:
		emit_signal("square_pos", square.get_position()) #to piece med pos
	
func _connect_piece_to_game_manager(piece_name):
	var dir = "Panel/Chessboard/" + piece_name
	var piece = get_node(dir)
	piece.connect("piece_chosen", self, "_chosen_piece")

func _connect_square_to_game_manager(square_name):
	var dir = "Panel/Chessboard/" + square_name
	var square = get_node(dir)
	square.connect("square_chosen", self, "_send_position")

func _connect_send_square_position(piece_name):
	var dir = "Panel/Chessboard/" + piece_name
	var piece = get_node(dir)
	self.connect("square_pos", piece, "_move_piece")


func _ready():
	var chessboard = get_node("Panel/Chessboard")
	var white_pawn_nodes = ["A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2"]
	var white_rook_nodes = ["A1", "H1"]
	var white_knight_nodes = ["B1", "G1"]
	var white_bishop_nodes = ["C1", "F1"]

	var red_pawn_nodes = ["A7", "B7", "C7", "D7", "E7", "F7", "G7", "H7"]
	var red_rook_nodes = ["A8", "H8"]
	var red_knight_nodes = ["B8", "G8"]
	var red_bishop_nodes = ["C8", "F8"]
	
	# Place white pieces
	var counter = 0
	var piece_name = ""
	for node_name in white_pawn_nodes:
		piece_name = "W" + "pawn" + str(counter)  
		place_piece(chessboard, node_name, pawn, piece_name)
		counter = counter +1 
	
	_connect_square_to_game_manager("H6")
	counter = 0
	for node_name in white_rook_nodes:
		piece_name = "W" + "rook" + str(counter)  
		place_piece(chessboard, node_name, rook, piece_name)
		_connect_piece_to_game_manager(piece_name)
		_connect_square_to_game_manager(node_name)
		_connect_send_square_position(piece_name)
		counter = counter +1 
	
	counter = 0
	for node_name in white_knight_nodes:
		piece_name = "W" + "knight" + str(counter) 
		place_piece(chessboard, node_name, knight, piece_name)
		counter = counter +1 
	
	counter = 0
	for node_name in white_bishop_nodes:
		piece_name = "W" + "bishop" + str(counter) 
		place_piece(chessboard, node_name, bishop, piece_name)
		counter = counter +1 
	
	piece_name = "W" + "queen"
	place_piece(chessboard, "D1", queen, piece_name)
	piece_name = "W" + "king"
	place_piece(chessboard, "E1", king, piece_name)	
	
	# Place red pieces
	counter = 0
	for node_name in red_pawn_nodes:
		piece_name = "R" + "pawn" + str(counter)
		place_piece(chessboard, node_name, red_pawn, piece_name)
		counter = counter +1 
	
	counter = 0
	for node_name in red_rook_nodes:
		piece_name = "R" + "rook" + str(counter)
		place_piece(chessboard, node_name, red_rook, piece_name)
		counter = counter +1 
		
	counter = 0	
	for node_name in red_knight_nodes:
		piece_name = "R" + "knight" + str(counter)
		place_piece(chessboard, node_name, red_knight, piece_name)
		counter = counter +1 
	
	counter = 0
	for node_name in red_bishop_nodes:
		piece_name = "R" + "bishop" + str(counter)
		place_piece(chessboard, node_name, red_bishop, piece_name)
		counter = counter +1 
	
	piece_name = "R" + "queen"	
	place_piece(chessboard, "D8", red_queen, piece_name)
	piece_name = "R" + "king"	
	place_piece(chessboard, "E8", red_king, piece_name)
