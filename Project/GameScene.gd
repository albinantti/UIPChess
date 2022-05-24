extends Node2D

var chosen_piece

var white_turn = 0
var red_turn = 1
var turn = white_turn

signal square_pos(pos, chosen_piece, new_turn)
#signal move_piece(piece_name, target_pos)

var pawn = preload("res://Resources/ChessPieces/pawn.svg")
var rook = preload("res://Resources/ChessPieces/rook.svg")
var knight = preload("res://Resources/ChessPieces/knight.svg")
var bishop = preload("res://Resources/ChessPieces/bishop.svg")
var king = preload("res://Resources/ChessPieces/king.svg")
var queen = preload("res://Resources/ChessPieces/queen.svg")

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
	print("Ive chosen" + piece.name)
	if chosen_piece == null: 
		chosen_piece = piece
	elif piece != chosen_piece and piece.input_pickable and _is_same_color(chosen_piece,piece): 
		var is_white = _is_white_piece(piece)
		if turn==white_turn and is_white:  
			chosen_piece = piece
			piece.modulate = Color(0.90,0.50,0.04,1)
			print("chosen piece is white", chosen_piece.name)
		elif turn==red_turn and !is_white:
			chosen_piece = piece
			piece.modulate = Color(0.90,0.50,0.04,1)
			print("chosen piece is white", chosen_piece.name)
			
func _is_same_color(chosen_piece,piece)->bool:
	if _is_white_piece(chosen_piece) and _is_white_piece(piece): 
		return true
	if !_is_white_piece(chosen_piece) and !_is_white_piece(piece): 
		return true
	return false

func _is_white_piece(piece)->bool:
	if piece.name.left(1) == "W":
		return true 
	return false

func _send_position(square):
	if chosen_piece != null:
		if square.get_position() != chosen_piece.get_position():
			_change_turn() #when a piece has moved, change turn
			emit_signal("square_pos", square.get_position(), chosen_piece, turn) #to piece with pos
			chosen_piece = null
		
	
func _change_turn(): 
	var arrow_red = self.get_node("Panel/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/arrow_red_turn")
	var arrow_white = self.get_node("Panel/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/arrow_white_turn")
	
	if turn==white_turn: #change to reds turn
		arrow_white.visible = false
		arrow_red.visible = true
		turn = red_turn
		 
	else: #change to whites turn
		arrow_white.visible = true
		arrow_red.visible = false	
		turn = white_turn		

func get_turn(): 
	return turn 
	
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

func _place_all_pieces(chessboard):
	var all_pieces = {
		"white_pawns": {
			"nodes": ["A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2"],
			"texture": pawn,
			"name_prefix": "Wpawn"
		},
		"white_rooks": {
			"nodes": ["A1", "H1"],
			"texture": rook,
			"name_prefix": "Wrook"
		},
		"white_knights": {
			"nodes": ["B1", "G1"],
			"texture": knight,
			"name_prefix": "Wknight"
		},
		"white_bishops": {
			"nodes": ["C1", "F1"],
			"texture": bishop,
			"name_prefix": "Wbishop"
		},
		"white_queen": {
			"nodes": ["D1"],
			"texture": queen,
			"name_prefix": "Wqueen"
		},
		"white_king": {
			"nodes": ["E1"],
			"texture": king,
			"name_prefix": "Wking"
		},
		"red_pawns": {
			"nodes": ["A7", "B7", "C7", "D7", "E7", "F7", "G7", "H7"],
			"texture": pawn,
			"name_prefix": "Rpawn"
		},
		"red_rooks": {
			"nodes": ["A8", "H8"],
			"texture": rook,
			"name_prefix": "Rrook"
		},
		"red_knights": {
			"nodes": ["B8", "G8"],
			"texture": knight,
			"name_prefix": "Rknight"
		},
		"red_bishops": {
			"nodes": ["C8", "F8"],
			"texture": bishop,
			"name_prefix": "Rbishop"
		},
		"red_queen": {
			"nodes": ["D8"],
			"texture": queen,
			"name_prefix": "Rqueen"
		},
		"red_king": {
			"nodes": ["E8"],
			"texture": king,
			"name_prefix": "Rking"
		},
	}

	for key in all_pieces:
		var current_pieces = all_pieces[key]
		var counter = 0

		for node_name in current_pieces['nodes']:
			var piece_name = current_pieces.name_prefix + str(counter)
			place_piece(chessboard, node_name, current_pieces['texture'], piece_name)
			_connect_piece_to_game_manager(piece_name)
			_connect_send_square_position(piece_name)
			counter += 1

func _ready():
	var chessboard = get_node("Panel/Chessboard")
	for square in chessboard.get_children():
		_connect_square_to_game_manager(square.name)

	_place_all_pieces(chessboard)
	
	#set the first turn to white players turn 
	var arrow_red = self.get_node("Panel/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/arrow_red_turn")
	arrow_red.visible = false
