extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_import_assembly_product_confirmed():
	
	# 输入路径后导入模型
	$"../../HSplitContainer2/VSplitContainer/VBoxContainer2/BoxContainer/assemblyProduct".confirm_model_select()
	$"../../HSplitContainer2/VSplitContainer/VBoxContainer2/TabContainer/产品管理/Tree".assemblyObjectList = \
		$"../../HSplitContainer2/VSplitContainer/VBoxContainer2/BoxContainer/assemblyProduct".assemblyObjectList
	$"../../HSplitContainer2/VSplitContainer/VBoxContainer2/TabContainer/产品管理/Tree".update_assembly_object_tree()
	$"../../HSplitContainer2/VSplitContainer/VBoxContainer/VBoxContainer/TabContainer/装配对象3D模型/ItemList".model = \
		$"../../HSplitContainer2/VSplitContainer/VBoxContainer2/BoxContainer/assemblyProduct".assemblyModel
	$"../../HSplitContainer2/VSplitContainer/VBoxContainer/VBoxContainer/TabContainer/装配对象3D模型/ItemList".update_model_list()
	$"../../HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".set_AssemblyModel_scene()
	
	
