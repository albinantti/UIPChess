extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_text(tr("NEW_GAME_TIME_VALUE").format({value="5"}))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayTimeSlider_value_changed(value):
	set_text(tr("NEW_GAME_TIME_VALUE").format({value=str(value)})) # Replace with function body.
