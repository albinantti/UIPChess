extends Node2D
var undo_stack = []
var redo_stack = []
var chosen_piece

var white_turn = 0
var red_turn = 1
var turn = white_turn
var is_moving = false

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
			if chosen_piece != null and square.get_position() != chosen_piece.get_position():
				var piece_knocked_out = des_piece.name if des_piece else ""
				var strings = PoolStringArray([
					chosen_piece.name,
					str(chosen_piece.get_position().x),
					str(chosen_piece.get_position().y),
					str(square.get_position().x),
					str(square.get_position().y),
					piece_knocked_out
				])
				var undo_string = strings.join(",")
				undo_stack.append(undo_string)
				redo_stack.clear()
				_refresh_history_panel()
				self.get_node("PieceSwipe").play()
			if des_piece != null: #there is a target opponent piece
				var t = Timer.new()
				t.set_wait_time(1)
				add_child(t)
				t.start()
				yield(t, "timeout")
				des_piece.visible = false
				des_piece.input_pickable = false
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

func _change_turn(object, _key):
	if chosen_piece == object:
		_change_turn_helper()

		chosen_piece = null
		is_moving = false


func _change_turn_helper():
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
			var piece_knocked_out_name = squares[5]
			if piece_knocked_out_name != "":
				var piece_knocked_out = get_node("Panel/Chessboard/" + piece_knocked_out_name)
				if do_undo:
					piece_knocked_out.visible = true
					piece_knocked_out.input_pickable = true
				else:
					piece_knocked_out.visible = false
					piece_knocked_out.input_pickable = false
			var previous_position = Vector2(x, y)
			moved_piece.set_position(previous_position)
			secondary_stack.append(move)
		else:
			primary_stack.append(move)
		self.get_node("PiecePlace").play()
		_change_turn_helper()
	_refresh_history_panel()


func _refresh_history_panel():
	var round_counter = 1.0
	var output = ""
	for line in undo_stack:
		output += _format_round_counter(round_counter) + _format_unredo_stack_line(line)
		round_counter += 0.5
	self.get_node("Panel/VBoxContainer/PanelContainer2/VBoxContainer/ScrollContainer/History/UndoStackContents").set_text(output)

	output = ""
	# Go through the redo stack inverted to get the latest move at the top
	for index in range(redo_stack.size(), 0, -1):
		var line = redo_stack[index - 1]
		output +=  _format_round_counter(round_counter) + _format_unredo_stack_line(line)
		round_counter += 0.5
	self.get_node("Panel/VBoxContainer/PanelContainer2/VBoxContainer/ScrollContainer/History/RedoStackContents").set_text(output)


func _format_round_counter(counter):
	# Returns a correct round counter string to be used in refresh history panel
	if (fmod(counter, 1.0) == 0.0):
		return "  " + str(floor(counter)) + "W. "
	return "  " + str(floor(counter)) + "R. "


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
