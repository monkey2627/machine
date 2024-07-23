extends Control

#var model1 = preload("res://Model/AssemblyModel/扳手工具.obj")
#var model2 = preload("res://Model/AssemblyModel/zzt5.glb")
#var model3 = preload("res://Model/AssemblyModel/新扳手.obj")
@onready var scene = $SubViewport/tbScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func show_model(path):
	var model = load(path)
	scene.change_model(model)

func play_assembly_anima():
	var WorkStepList = $"../../../../VBoxContainer/TabContainer/工艺管理/Tree".gongbu_list
	var WorkStep_to_therblig = $"../../../../../../../Data/Model".WorkStep_to_therblig
	scene.play_all_anima(WorkStepList, WorkStep_to_therblig)
	pass

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
			KEY_S:
				scene.Camera._s = event.pressed
			KEY_A:
				scene.Camera._a = event.pressed
			KEY_D:
				scene.Camera._d = event.pressed
			KEY_Q:
				scene.Camera._q = event.pressed
			KEY_E:
				scene.Camera._e = event.pressed
