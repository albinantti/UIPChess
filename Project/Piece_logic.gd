extends Area2D

signal piece_chosen(piece)

var piece_chosen = false

var velocity = Vector2()

var white_turn = 0 
var red_turn = 1
var turn = white_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name.left(1) == "R": #initiating all red pieces as red
		self.modulate = Color(0.89, 0.21, 0.21, 1) #red
	pass # Replace with function body.

func _is_white()->bool: 
	if self.name.left(1) == "R":
		return false
	return true

func _input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal('piece_chosen', self)
		piece_chosen = true

## Hovering over piece
func _mouse_enter():
	if self.modulate != Color(0.90,0.50,0.04,1): #piece not chosen
		self.modulate = Color(0.89,0.67,0.09,1) #light orange

## Hovering over piece, exiting piece
func _mouse_exit():
	if self.modulate != Color(0.90,0.50,0.04,1): #piece not chosen
		if  _is_white(): #if first letter is W (White) go back to white
			self.modulate = Color(1, 1, 1, 1) #white 
		elif !_is_white():
			self.modulate = Color(0.89, 0.21, 0.21, 1) #red
