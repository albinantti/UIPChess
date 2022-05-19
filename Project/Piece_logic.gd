extends Area2D

signal piece_chosen(piece)
var piece_chosen = false

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name.left(1) == "R": #initiating all red pieces as red
		self.modulate = Color(0.89, 0.21, 0.21, 1) #red
	pass # Replace with function body.


func _process(state):
	pass
#func move():
#	if Input.is_action_pressed('ui_right'):
#		apply_central_impulse(Vector2(0, 10))
	
#func _on_Area2D_input_event(viewport, event, shape_idx):
#	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
#		print("lol it works")
#		print(self.name)
#		emit_signal('piece_chosen', self.name)

func _move_piece(new_position, chosen_piece):
	if chosen_piece.name == self.name:
		self.modulate = Color(1,1,1,1)
		piece_chosen = false
		var TweenNode = get_node("Tween")
		TweenNode.interpolate_property(
			self, "position", get_position(), new_position, 
			2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT
		)
		TweenNode.start()
	elif new_position == self.get_position():
		self.input_pickable = false
		var t = Timer.new()
		t.set_wait_time(1)
		add_child(t)
		t.start()
		yield(t, "timeout")
		self.visible = false
		self.input_pickable = false

func _input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		self.modulate = Color(0.90,0.50,0.04,1)
		emit_signal('piece_chosen', self)
		piece_chosen = true

## Hovering over piece
func _mouse_enter():
	self.modulate = Color(0.89,0.67,0.09,1) #light orange

## Hovering over piece, exiting piece
func _mouse_exit():
	if !piece_chosen:
		if self.name.left(1) == "W": #if first letter is W (White) go back to white
			self.modulate = Color(1, 1, 1, 1) #white 
		else:
			self.modulate = Color(0.89, 0.21, 0.21, 1) #red
