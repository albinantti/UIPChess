extends Node2D

var chosen_piece

var white_turn = 0
var red_turn = 1
var turn = white_turn
var is_moving = false 

signal check_positon_against_piece(position_of_square)

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

##-----------Help functions--------------
func _is_same_color(piece1,piece2)->bool:
	if piece1==null or piece2==null:
		return false
	if _is_white_piece(piece1) and _is_white_piece(piece2): 
		return true
	if !_is_white_piece(piece1) and !_is_white_piece(piece2): 
		return true
	return false

func _is_white_piece(piece)->bool:
	if piece == null: 
		return false
	if piece.name.left(1) == "W":
		return true 
	return false

func _is_red_piece(piece)->bool:
	if piece == null: 
		return false
	if piece.name.left(1) == "R":
		return true 
	return false

func _get_arr_pieces()->Array: 
	var chessboard = get_node("Panel/Chessboard")
	var children = chessboard.get_children()
	
	var pieces = []
	for child in children: 
		if child.visible and (_is_white_piece(child) or _is_red_piece(child)): 
			pieces.append(child)
	return pieces

func _reset_chosen_piece_color(): 
	if _is_white_piece(chosen_piece): 
		chosen_piece.modulate = Color(1, 1, 1, 1)
	else: 
		chosen_piece.modulate = Color(0.89, 0.21, 0.21, 1)
#------------------------------------

## Listens on inputed piece from "Piece_logic.gd"
func _chosen_piece(piece):
	if !is_moving: 
		_set_chosen_piece(piece)

## Sets the variable "Chosen_piece"
func _set_chosen_piece(piece): 
	var is_white = _is_white_piece(piece)
	# if it is the first time this round that chosen_piece is set
	# can only choose a piece that is the same color as the turn 
	if chosen_piece == null and ((turn==white_turn and is_white) or (turn==red_turn and !is_white)): 
		chosen_piece = piece 
		chosen_piece.modulate = Color(0.90,0.50,0.04,1)
	# if there already is a chosen piece, choose another piece to attack with 
	elif chosen_piece != null and _is_same_color(chosen_piece, piece): 
		if _is_white_piece(chosen_piece):
			chosen_piece.modulate = Color(1, 1, 1, 1)
		else:
			chosen_piece.modulate = Color(0.89, 0.21, 0.21, 1)
		chosen_piece = piece # set the new chosen piece to chosen_piece
		chosen_piece.modulate = Color(0.90,0.50,0.04,1) 		

## Listens on inputed square from "Square_logic.gd"
func _send_position(square):
	# if there are a piece to move and the position to move it to is not it´s own 
	if !is_moving and chosen_piece != null and square.get_position() != chosen_piece.get_position(): 
		_move_piece(square)

## Moves the chosen piece to the destination 
func _move_piece(square):
	if !is_moving: 
		var new_position = square.get_position()
		var des_piece = _check_after_piece_on_des(new_position)
		#if there are no piece on the des or if the piece on the des is an opponent piece 
		if  des_piece == null or !_is_same_color(chosen_piece,des_piece):
			_reset_chosen_piece_color()
			var TweenNode = chosen_piece.get_node("Tween")
			TweenNode.interpolate_property(
				chosen_piece, "position", chosen_piece.get_position(), new_position, 
				2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT
			)
			TweenNode.start()
			is_moving = true
			if des_piece != null: #there is a target opponent piece
				var t = Timer.new()
				t.set_wait_time(1)
				add_child(t)
				t.start()
				yield(t, "timeout")
				des_piece.visible = false
				des_piece.input_pickable = false
			#_change_turn() #has to be here so that turn changes only when piece has disapeared 
								#can otherwise be chosed as a target
		else: 
			_set_chosen_piece(des_piece) #change the chosen_piece to the new chosen piece

# Checks if there is a piece on the destination square, 
# returns the piece if it finds it, else null
func _check_after_piece_on_des(des_position)->Area2D:
	var pieces_arr = _get_arr_pieces()
	var piece = _check_if_same_pos(pieces_arr, des_position)
	return piece 

# Checks if any of the pieces has the same position as the destination square
# if there are: return the piece, else null 
func _check_if_same_pos(pieces, pos)->Area2D: 
	for piece in pieces: 
		if piece.get_position() == pos: 
			return piece
	return null

func _change_turn(object, key): 
	if chosen_piece == object:
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
		chosen_piece = null	
		is_moving = false

func _connect_piece_to_game_manager(piece_name):
	var dir = "Panel/Chessboard/" + piece_name
	var piece = get_node(dir)
	piece.connect("piece_chosen", self, "_chosen_piece")

func _connect_square_to_game_manager(square_name):
	var dir = "Panel/Chessboard/" + square_name
	var square = get_node(dir)
	square.connect("square_chosen", self, "_send_position")

func _connect_tween_to_game_manager(piece_name): 
	var dir = "Panel/Chessboard/" + piece_name
	var piece = get_node(dir)
	var tween = piece.get_node("Tween")
	tween.connect("tween_completed", self, "_change_turn")
	
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
			_connect_tween_to_game_manager(piece_name)
			counter += 1

func _ready():
	var chessboard = get_node("Panel/Chessboard")
	for square in chessboard.get_children():
		_connect_square_to_game_manager(square.name)

	_place_all_pieces(chessboard)
	
	#set the first turn to white players turn 
	var arrow_red = self.get_node("Panel/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/arrow_red_turn")
	arrow_red.visible = false
