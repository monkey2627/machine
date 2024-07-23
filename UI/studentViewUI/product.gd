extends Control

@onready var  project_path = get_node("/root/Global").project_path
var saveName = "product.json"
var product ={}


@export var gongyiTreeNode:Node
@export var assemblyObjectsNode:Node
# Called when the node enters the scene tree for the first time.
func _ready():
	product.name = "产品"
	product.desc = "哈哈哈"
	product.owner = "wzj"
	product.date  = "2023-07-07"
	product.modifydate = "2023-07-07"
	product.modifyperson = "wzj"

	pass # Replace with function body.


func set_allData():
	gongyiTreeNode.set_gongyi(product.gongyi)
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


	for item in product.assembly_objects:
		item.color = str2Color(item.color)
		item.position = str2Vector3(item.position)
		item.rotation = str2Vector3(item.rotation)
		item.scale = str2Vector3(item.scale)
		
	assemblyObjectsNode.WorkStep_to_therblig = work_step2therblig
	assemblyObjectsNode.assemblyObjectList = product.assembly_objects
	assemblyObjectsNode.assemblyModel = product.assembly_objects_models
	$"ColorRect/VSplitContainer/HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".assemblyProductClass = $Data/Model
	$"ColorRect/VSplitContainer/HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".set_AssemblyModel_scene()






func load_product():
	
	var save_path = project_path + "\\" + saveName
	var file = FileAccess.open(save_path, FileAccess.READ)
	var content = file.get_as_text()
	product = JSON.parse_string(content)
	set_allData()
	print(product)


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





