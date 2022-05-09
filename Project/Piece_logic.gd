extends RigidBody2D

signal piece_chosen(piece_name)

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

#func _integrate_forces(state):
	#move()
	#self.AddForce ((target - .transform.position) * travelSpeed)
#	pass
	
#func move():
#	if Input.is_action_pressed('ui_right'):
#		apply_central_impulse(Vector2(0, 10))
	
func _on_RigidBody2D_input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("lol it works")
		print(self.name)
		emit_signal('piece_chosen', self.name)

