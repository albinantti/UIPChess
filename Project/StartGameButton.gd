extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _pressed():
	get_node("NewGameSettingsBG").visible = true
	#get_tree().change_scene("res://GameScene.tscn")


func _on_Load_Game_pressed():
	get_node("NewGameSettingsBG").visible = false


func _on_Tutorial_pressed():
	get_node("NewGameSettingsBG").visible = false


func _on_Settings_pressed():
	get_node("NewGameSettingsBG").visible = false


func _on_ExitButton_pressed():
	get_node("NewGameSettingsBG").visible = false
