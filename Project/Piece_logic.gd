extends Area2D

signal piece_chosen(piece)

var velocity = Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
		var TweenNode = get_node("Tween")
		TweenNode.interpolate_property(
			self, "position", get_position(), new_position, 
			2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT
		)
		TweenNode.start()
	elif new_position == self.get_position():
		var t = Timer.new()
		t.set_wait_time(1)
		add_child(t)
		t.start()
		yield(t, "timeout")
		self.visible = false
		self.input_pickable = false

func _input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal('piece_chosen', self)
