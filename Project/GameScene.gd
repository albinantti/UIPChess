extends Node2D

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
func place_piece(chessboard: Node, node_name: String, texture: Resource, piece_name:String) -> void:
	
	var node_rect = node_name + "_rect"
	var area = chessboard.get_node(node_name)
	var	node = area.get_node(node_rect)
	var sprite = Sprite.new()
	var sprite_x = area.get_position().x + node.get_size().x / 2
	var sprite_y = area.get_position().y + node.get_size().y / 2
	sprite.set_position(Vector2(sprite_x, sprite_y))
	sprite.texture = texture
	sprite.set_scale(Vector2(0.433, 0.433))
	
	var rigidBody = _create_rigidBody(piece_name)
	var collisionShape = _create_collisionshape(node, sprite_x, sprite_y)
	
	rigidBody.add_child(collisionShape)
	rigidBody.add_child(sprite)
	chessboard.add_child(rigidBody)
	
#Create the body of a piece
func _create_rigidBody(piece_name:String)->RigidBody2D:
	var rigidBody = RigidBody2D.new()
	rigidBody.set_script(load("res://Piece_logic.gd"))
	rigidBody.name = piece_name #set name to every 
	rigidBody.set_mode(2) #2 means character body
	rigidBody.input_pickable = true #in order to click on it
	rigidBody.gravity_scale = 0
	return rigidBody

# Create a collisonshape for a piece where the mouse clicks will be identified
func _create_collisionshape(node: Node, sprite_x:float, sprite_y:float)->CollisionShape2D:
	var collisionShape = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	var size = node.get_size() 
	print(size)
	shape.set_extents(Vector2(size)) #set the size of the collsionshape as the node
	collisionShape.set_shape(shape)
	collisionShape.set_scale(Vector2(0.433, 0.433)) #set the scale to the same as the sprite
	collisionShape.set_position(Vector2(sprite_x, sprite_y)) #set the position to the same as the sprite
	return collisionShape

func _chosen_piece(piece_name):
	print("chosen piece!")
	print(piece_name)
	pass
	
func _connect_pieces_to_input_event(piece_name:String)-> void:
	var dir = "Panel/Chessboard/" + piece_name
	var rigid = get_node(dir)
	rigid.connect("input_event", rigid, "_on_RigidBody2D_input_event")
	
# Called when the node enters the scene tree for the first time.
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
	
	counter = 0
	for node_name in white_rook_nodes:
		piece_name = "W" + "rook" + str(counter)  
		place_piece(chessboard, node_name, rook, piece_name)
		_connect_pieces_to_input_event(piece_name)
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
	
	var dir = "Panel/Chessboard/" + "Wrook1"
	var rigid = get_node(dir)
	rigid.connect("piece_chosen", self, "_chosen_piece")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


