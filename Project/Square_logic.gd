extends Area2D

signal square_chosen(square)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_set_collisionshape_size()

# Set the collisionshape to the same size as the ColorRectangle
func _set_collisionshape_size():
	var collisionShape = self.get_node("CollisionShape2D")
	var shape = collisionShape.get_shape()
	var rect_name = self.name + "_rect"
	var rect = self.get_node(rect_name)
	
	var size = (rect.get_size())/2 
	shape.set_extents(Vector2(size)) # set the size of the collsionshape as the rectangle
	collisionShape.set_shape(shape)
	
	# position is relative to the area2D and the origin of the collisionshape is in the center
	collisionShape.set_position(Vector2(size))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
		
func _input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("random text")
		emit_signal("square_chosen", self)
