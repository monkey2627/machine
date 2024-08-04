extends Control

#@onready var  project_path = get_node("/root/Global").project_path
@onready var  project_path = "save_data"
var saveName = "product.json"
var product ={}

# Called when the node enters the scene tree for the first time.
func _ready():
	product.name = "产品"
	product.desc = "哈哈哈"
	product.owner = "wzj"
	product.date  = "2023-07-07"
	product.modifydate = "2023-07-07"
	product.modifyperson = "wzj"

	pass # Replace with function body.

func get_allData():
	
	#product.id = 1

	product.gongyi = $"ColorRect/VSplitContainer/HSplitContainer2/VSplitContainer/VBoxContainer2/TabContainer/工艺管理/Tree".gongyi
	var tmp= $"ColorRect/VSplitContainer/HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/VSplitContainer/TabContainer/动素管理".WorkStep_to_therblig
	product.WorkStep_to_therblig = {}
	for key in tmp:
		product.WorkStep_to_therblig[key] = []
		for value in tmp[key]:
			if value is Dictionary:
				product.WorkStep_to_therblig[key].push_back(value)
			else:
				product.WorkStep_to_therblig[key].push_back(inst_to_dict(value))
	
	product.assembly_objects = $"ColorRect/VSplitContainer/HSplitContainer2/VSplitContainer/VBoxContainer2/TabContainer/产品管理/Tree".assemblyObjectList
	product.assembly_objects_models = $"ColorRect/VSplitContainer/HSplitContainer2/VSplitContainer/VBoxContainer/VBoxContainer/TabContainer/装配对象3D模型/ItemList".model

func set_allData():
	$"ColorRect/VSplitContainer/HSplitContainer2/VSplitContainer/VBoxContainer2/TabContainer/工艺管理/Tree".set_gongyi(product.gongyi)
	var work_step2therblig = {}
	for key in product.WorkStep_to_therblig:
		work_step2therblig[int(key)] = []
		for tb in product.WorkStep_to_therblig[key]:
			var tmp = {}
			for key2 in tb:
				if key2 == "@path" or key2 == "@subpath" or key2 == "anima" or key2 == "model": 
					continue
				if key2 == "startpos":
					tmp[key2] = str2Vector3(tb[key2])
					continue 
				if key2 == "endpos":
					tmp[key2] = str2Vector3(tb[key2])
					continue 
				if key2 == "type":
					tmp[key2] = int(tb[key2])
					continue 
				if key2 == "modelID":
					tmp[key2] = int(tb[key2])
					continue 
				if key2 == "toolID":
					tmp[key2] = int(tb[key2])
					continue 
				tmp[key2] = tb[key2]
			work_step2therblig[int(key)].push_back(tmp)	
	
	$"ColorRect/VSplitContainer/HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/VSplitContainer/TabContainer/动素管理".set_WorkStep_to_therblig(work_step2therblig)
	
	for item in product.assembly_objects:
		item.color = str2Color(item.color)
		item.position = str2Vector3(item.position)
		item.rotation = str2Vector3(item.rotation)
		item.scale = str2Vector3(item.scale)
	$"ColorRect/VSplitContainer/HSplitContainer2/VSplitContainer/VBoxContainer2/TabContainer/产品管理/Tree".set_assembly_objects(product.assembly_objects)
	$"ColorRect/VSplitContainer/HSplitContainer2/VSplitContainer/VBoxContainer/VBoxContainer/TabContainer/装配对象3D模型/ItemList".set_assembly_objects_models(product.assembly_objects_models)
	$"ColorRect/VSplitContainer/HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".set_AssemblyModel_scene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func save_product():
	get_allData()
	var product_json = JSON.stringify(product,"\t")
	var save_path = project_path + "\\" + saveName
	print(save_path)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#var error = file.open_encrypted_with_pass(save_path, File.WRITE, "124s5d4asd5")
	#if error == OK:
	file.store_string(product_json)
	#file.close()

	pass # Replace with function body.

func load_product():
	
	var save_path = project_path + "\\" + saveName
	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	product = JSON.parse_string(content)
	set_allData()
#	print(product)


func str2Vector3(str:String):
	
	var tmp = str.trim_prefix("(")
	tmp = tmp.trim_suffix(")")
	var arr = tmp.split(",")
	return Vector3(float(arr[0]),float(arr[1]),float(arr[2]))


func str2Color(str:String):
	var tmp = str.trim_prefix("(")
	tmp = tmp.trim_suffix(")")
	var arr = tmp.split(",")
	return Color(float(arr[0]),float(arr[1]),float(arr[2]),float(arr[2]))
