extends Node2D
var undo_stack = []
var redo_stack = []
var chosen_piece
signal square_pos(pos,chosen_piece)
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

	var collisionShape = _create_collisionshape(color_rect)

	# Add Tween for movement animation
	var tween = Tween.new()
	tween.name = "Tween"
	tween.set_speed_scale(5.0)

	area2d.add_child(collisionShape)
	area2d.add_child(sprite)
	area2d.add_child(tween)
	chessboard.add_child(area2d)

## Create a collisonshape for a piece where the mouse clicks will be identified
func _create_collisionshape(node: Node)->CollisionShape2D:
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
	if piece != chosen_piece and piece.input_pickable and chosen_piece==null: 
		chosen_piece = piece
		print("chosen piece ", chosen_piece.name)


func _send_position(square):
	if chosen_piece != null and square.get_position() != chosen_piece.get_position():
		emit_signal("square_pos", square.get_position(), chosen_piece) #to piece with pos
		var strings = PoolStringArray([
			chosen_piece.name,
			str(chosen_piece.get_position().x),
			str(chosen_piece.get_position().y),
			str(square.get_position().x),
			str(square.get_position().y)
		])
		var undo_string = strings.join(",")
		undo_stack.append(undo_string)
		redo_stack.clear()
		chosen_piece = null
		_refresh_history_panel()
		self.get_node("PieceSwipe").play()

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
	var error_msg = self.connect("square_pos", piece, "_move_piece")
	if error_msg != OK:
		print("ERROR: " + error_msg)

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

		# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	var error_code = get_tree().connect("node_added", self, "_on_SceneTree_node_added")
	if error_code != OK:
		print("ERROR: ", error_code)


func _on_SceneTree_node_added(node):
	if node is Button:
		connect_to_button(node)

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button):
	var error_code = button.connect("pressed", self, "_on_Button_pressed")
	if error_code != OK:
		print("ERROR: ", error_code)


func _on_Button_pressed():
	self._play_button_pressed_sound()


func _play_button_pressed_sound():
	self.get_node("ButtonPress").play()


## Undoes the previous move if do_undo is true, if any.
## Otherwise it redos the latest move that was undone, if any.
func _undo_redo(do_undo: bool):
	# The primary stack is the stack that will get it's latest move
	# poped and reintroduced into the game.
	# If an undo is made, the primary stack will be the undo stack,
	# i.e. the latest move will be undone. This move is then pushed to the
	# secondary stack, in this case the redo stack, so that the move can be
	# redone again
	var primary_stack = undo_stack if do_undo else redo_stack
	var secondary_stack = redo_stack if do_undo else undo_stack
	if primary_stack:
		var move = primary_stack.pop_back()
		var squares = move.rsplit(",")
		var moved_piece = get_node("Panel/Chessboard/" + squares[0])
		if not moved_piece.get_node("Tween").is_active():
			var x = squares[1] if do_undo else squares[3]
			var y = squares[2] if do_undo else squares[4]
			var previous_position = Vector2(x, y)
			moved_piece.set_position(previous_position)
			secondary_stack.append(move)
		else:
			primary_stack.append(move)
		self.get_node("PiecePlace").play()
	_refresh_history_panel()


func _refresh_history_panel():
	var round_counter = 1
	var output = ""
	for line in undo_stack:
		output += "  " + str(round_counter) + ". " + _format_unredo_stack_line(line)
		round_counter += 1
	self.get_node("Panel/VBoxContainer/PanelContainer2/VBoxContainer/ScrollContainer/History/UndoStackContents").set_text(output)

	output = ""
	var redo_stack_inverted = redo_stack
	redo_stack_inverted.invert()
	for line in redo_stack_inverted:
		output += "  " + str(round_counter) + ". " + _format_unredo_stack_line(line)
		round_counter += 1
	self.get_node("Panel/VBoxContainer/PanelContainer2/VBoxContainer/ScrollContainer/History/RedoStackContents").set_text(output)

func _format_unredo_stack_line(line):
	# Formats a line from the undo/redo stack to be listed in the history panel
	var line_split = line.split(",")
	var from_tile = str(_pixel_to_tile_converter(line_split[1], line_split[2]))
	var to_tile = str(_pixel_to_tile_converter(line_split[3], line_split[4]))
	return (from_tile + " -> " + to_tile + "\n")


func _pixel_to_tile_converter(x,y):
	# Takes an x, y worldunit coordinate and returns a 2 character string for
	# whichever tile it represents.
	var ranks = ["A","B","C","D","E","F","G","H"]
	# warning-ignore:integer_division
	# warning-ignore:integer_division
	return str(ranks[(int(x)/65)]) + str(8-int(y) / 65)



func _on_UndoButton_pressed():
	_undo_redo(true)

func _on_RedoButton_pressed():
	_undo_redo(false)
