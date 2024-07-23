extends Control

var testmodelPath = "res://Model/AssemblyModel/新扳手.obj"
@onready var scene = $SubViewport/tbScene
@onready var camera3D = $SubViewport_3D/Node3D/Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func show_model(path):
	var model = load(path)
	scene.change_model(model)

func play_assembly_anima():
	var WorkStepList = $"../../../../VSplitContainer/VBoxContainer2/TabContainer/工艺管理/Tree".gongbu_list
	var WorkStep_to_therblig = $"VSplitContainer/TabContainer/动素管理".WorkStep_to_therblig
	scene.play_all_anima(WorkStepList, WorkStep_to_therblig)

func clear_tbScene():
	scene.clear_model()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
	
func _input(event):
	if event is InputEventKey:
		match event.keycode:
			KEY_W:
				scene.Camera._w = event.pressed
				camera3D._w = event.pressed
			KEY_S:
				scene.Camera._s = event.pressed
				camera3D._s = event.pressed
			KEY_A:
				scene.Camera._a = event.pressed
				camera3D._a = event.pressed
			KEY_D:
				scene.Camera._d = event.pressed
				camera3D._d = event.pressed
			KEY_Q:
				scene.Camera._q = event.pressed
				camera3D._q = event.pressed
			KEY_E:
				scene.Camera._e = event.pressed
				camera3D._e = event.pressed
#
#	if event is InputEventMouseButton:
#		print("发生了鼠标事件")
#		match event.button_index:
#			MOUSE_BUTTON_RIGHT:
#				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED  
#				if event.is_pressed() else Input.MOUSE_MODE_VISIBLE)
#

		
	#假如鼠标右键按下事件
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		scene.Camera.get_selection()
	pass

