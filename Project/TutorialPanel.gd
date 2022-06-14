extends Panel


# Declare member variables here. Examples:
var step1
var step2
var step3
var step4
var step5
var step6
var step7
var step8
var step9
var step10

var arrow1
var arrow2


# Called when the node enters the scene tree for the first time.
func _ready():
	step1 = get_node("Step1")
	step1.window_title = tr("TUTORIAL_STEP").format({value=str(1)})
	step2 = get_node("Step2")
	step2.window_title = tr("TUTORIAL_STEP").format({value=str(2)})
	step3 = get_node("Step3")
	step3.window_title = tr("TUTORIAL_STEP").format({value=str(3)})
	step4 = get_node("Step4")
	step4.window_title = tr("TUTORIAL_STEP").format({value=str(4)})
	step5 = get_node("Step5")
	step5.window_title = tr("TUTORIAL_STEP").format({value=str(5)})
	step6 = get_node("Step6")
	step6.window_title = tr("TUTORIAL_STEP").format({value=str(6)})
	step7 = get_node("Step7")
	step7.window_title = tr("TUTORIAL_STEP").format({value=str(7)})
	step8 = get_node("Step8")
	step8.window_title = tr("TUTORIAL_STEP").format({value=str(8)})
	step9 = get_node("Step9")
	step9.window_title = tr("TUTORIAL_STEP").format({value=str(9)})
	step10 = get_node("Step10")
	step10.window_title = tr("TUTORIAL_STEP").format({value=str(10)})

	arrow1 = get_node("TutorialArrow")
	arrow2 = get_node("TutorialArrow2")

	get_node("ArrowAnimation").play("Rocking")

	# Connect step buttons to respective functions
	for step in self.get_children():
		if step is WindowDialog:
			step.get_node("NextStep").connect("pressed", self, step.name.to_lower() + "next")
			step.get_node("PreviousStep").connect("pressed", self, step.name.to_lower() + "previous")
			step.get_close_button().hide()

	# If the tutorial bus is true, start tutorial.
	if (AudioServer.is_bus_mute(1)):
		self.visible = true
		step1.popup()

func step1previous():
	self.visible = false
	step1.visible = false
	AudioServer.set_bus_mute(1, 0)


# STEP 2
func step1next():
	step1.visible = false

	arrow1.visible = true
	arrow1.set_position(Vector2(740, 89))
	arrow1.set_rotation_degrees(-90)
	arrow2.visible = false

	step2.popup()

# STEP 1
func step2previous():
	step2.visible = false
	arrow1.visible = false
	arrow2.visible = false
	step1.popup()

# STEP 3
func step2next():
	step2.visible = false

	arrow1.visible = true
	arrow1.set_position(Vector2(688, 409))
	arrow1.set_rotation_degrees(38.8)
	arrow2.visible = true
	arrow2.set_position(Vector2(687, 199))
	arrow2.set_rotation_degrees(126.5)

	step3.popup()


# STEP 2
func step3previous():
	step3.visible = false
	step1next()


# STEP 4
func step3next():
	step3.visible = false
	step4.popup()
	arrow1.visible = true
	arrow1.set_position(Vector2(439, 395))
	arrow1.set_rotation_degrees(15)
	arrow2.visible = false

	# Highlight E2
	get_node("..").tutorial_helper(1)


# STEP 3
func step4previous():
	step4.visible = false

	# Unhighlight E2
	get_node("..").tutorial_helper(4)

	step2next()


# STEP 5
func step4next():
	step4.visible = false
	step5.popup()
	arrow1.visible = false
	arrow2.visible = false

	# Move E2 to E4
	get_node("..").tutorial_helper(2)

	#unselect pawn

# STEP 4
func step5previous():
	step5.visible = false

	# Move e4 to e2
	get_node("..").tutorial_helper(3)

	step3next()


# STEP 6
func step5next():
	step5.visible = false
	step6.popup()
	arrow1.visible = true
	arrow1.set_position(Vector2(73, 70))
	arrow1.set_rotation_degrees(135)
	arrow2.visible = false


# STEP 5
func step6previous():
	step6.visible = false
	step4.visible = false
	step5.popup()
	arrow1.visible = false
	arrow2.visible = false


# STEP 7
func step6next():
	step6.visible = false
	step7.popup()
	arrow1.visible = true
	arrow1.set_position(Vector2(810, 507))
	arrow1.set_rotation_degrees(0)
	arrow2.visible = true
	arrow2.set_position(Vector2(869, 507))
	arrow2.set_rotation_degrees(0)


# STEP 6
func step7previous():
	step7.visible = false
	step5next()


# STEP 8
func step7next():
	step7.visible = false
	step8.popup()
	arrow1.visible = true
	arrow1.set_position(Vector2(933, 507))
	arrow1.set_rotation_degrees(0)
	arrow2.visible = false


# STEP 7
func step8previous():
	step8.visible = false
	step6next()


# STEP 9
func step8next():
	step8.visible = false
	step9.popup()

	arrow1.visible = true
	arrow1.set_position(Vector2(992, 507))
	arrow1.set_rotation_degrees(0)
	arrow2.visible = false


# STEP 8
func step9previous():
	step9.visible = false
	step7next()


# STEP 10
func step9next():
	step9.visible = false
	step10.popup()
	arrow1.visible = false
	arrow2.visible = false


# STEP 9
func step10previous():
	step10.visible = false
	step8next()


# FINISHED
func step10next():
	step10.visible = false
	AudioServer.set_bus_mute(1, 0)
	var error_code = get_tree().change_scene("res://GameScene.tscn")
	if error_code != OK:
		print("ERROR: ", error_code)



