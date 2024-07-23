extends Control

var a = []

# 表示动素编号，每次新建一个动素，+1
var idx = 1

enum TherbligType 
{
	camera, 
	workstep, 
	tool,
	model
}

var TherbligType2name = ["相机", "工步", "工具", "模型"]

class CameraTb:
	var name:String
	var type:int
	var id:int
	var priority:int = 0
	
	var startpos:Vector3
	var endpos:Vector3
	var time:float
	var anima:Tween

class ToolTb:
	var name:String
	var type:int
	var id:int
	var priority:int = 0
	
	var time:float
	var toolID:int
	var model:MeshInstance3D
	
	var anima:Tween
	

enum WorkstepSignType 
{
	arrow,
	ball
}

var WorkstepSignType2name = ["箭头", "球型"]

class WorkstepTb:
	var name:String
	var type:int
	var id:int
	var priority:int = 0
	
	# 用于定义引导类型
	var signtype:int
	var model:MeshInstance3D
	
	var startpos:Vector3
	var endpos:Vector3
	var time:float
	var anima:Tween


class ModelTb :
	var name:String
	var type:int
	var id:int
	var priority:int = 0
	
	var startpos:Vector3
	var endpos:Vector3
	var time:float
	# 绑定的装配对象
	var modelID:int
	var model
	
	var anima:Tween


# 用于判断动素理界面是否存在
var if_exist = false

# 用于存储与该工步关联的装配资源，在点击"管理动素"时更新
@onready var toolBox = $"../../../../../../../VSplitContainer/VBoxContainer/VBoxContainer/TabContainer/装配资源3D模型/ItemList".model
# 用于存储与该工步关联的装配对象，树形结构
@onready var assmblyObjectTree = $ListAndButton/therbligsConnectObjectWin/SelectModel/Tree



# 用于记录临时的装配资源列表，在确认SelectTool时更新
var selected_toolID:int = -1
# 用于记录临时的装配对象列表，在确认SelectModel时更新
var selected_modelID:int = -1

# 用工步的id去索引该工步的动素list
var WorkStep_to_therblig = {}

# 表示当前查看的工步
var current_id:int = -1

@onready var gongyi_tree = $"../../../../../../../VSplitContainer/VBoxContainer2/TabContainer/工艺管理/Tree"


# 相关UI
@onready var TherbligItemList = $ListAndButton/ScrollContainer/HBoxContainer/ColorRect/ItemList

@onready var ListAndButton_SelectType = $ListAndButton/SelectType
@onready var ToolBoxItemList = $ListAndButton/AddToolTb/SelectTool/ItemList
@onready var ModelBoxItemList = $ListAndButton/AddModelTb/SelectModel/ItemList

# 动素显示窗口相关
@onready var TbSceneInstance = $"../../../SubViewport/tbScene"



#初始化数据
func initData():
#	WorkStep_to_therblig[1] = []
#	var item1 = ModelTb.new() 
#	item1.id = idx
#	item1.name = "侧板_1 安装"
#	item1.type = TherbligType.model
#	print(item1.type)
#	item1.startpos = Vector3(0,0,0)
#	item1.endpos = Vector3(0.25,-0.68,-1.08)
#	item1.time = 1
#	item1.model = 0
#	item1.anima = Tween.new()
#	idx = idx + 1
#	WorkStep_to_therblig[1].append(item1)
#
#	WorkStep_to_therblig[2] = []
#	var item2 = ModelTb.new() 
#	item2.id = idx
#	item2.name = "侧板_2 安装"
#	item2.type = TherbligType.model
#	item2.startpos = Vector3(0,0,0)
#	item2.endpos = Vector3(0.25,-0.68,1.08)
#	item2.time = 1
#	item2.model = 1
#	item2.anima = Tween.new()
#	idx = idx + 1
#	WorkStep_to_therblig[2].append(item2)
#
#	WorkStep_to_therblig[3] = []
#	var item3 = ModelTb.new() 
#	item3.id = idx
#	item3.name = "叶片_1 安装"
#	item3.type = TherbligType.model
#	item3.startpos = Vector3(0,0,0)
#	item3.endpos = Vector3(0.15,-1.01,0)
#	item3.time = 1
#	item3.model = 2
#	item3.anima = Tween.new()
#	idx = idx + 1
#	WorkStep_to_therblig[3].append(item3)
	pass

func set_WorkStep_to_therblig(therblig_dict):
	WorkStep_to_therblig = therblig_dict
	update_Therblig_list()
	pass
# 更新动素列表的显示
func update_Therblig_list():
	# 如果该工步没有动素list，则为它创建个
	if WorkStep_to_therblig.has(current_id) == false:
		TherbligItemList.clear()
		return 
	if TherbligItemList != null:
		TherbligItemList.clear()
		var cur_tb_list = WorkStep_to_therblig[current_id]
		for i in range(cur_tb_list.size()):
			var item = cur_tb_list[i]
			TherbligItemList.add_item(item.name)
			TherbligItemList.set_item_metadata(i, item)
		
		# 更新动素类型
		for i in range(cur_tb_list.size()):
			var list_node = TherbligItemList.get_item_metadata(i)
			var tip:String = TherbligItemList.get_item_text(i) + "\n类型: "
			tip = tip + TherbligType2name[list_node.type]
			TherbligItemList.set_item_tooltip(i,tip)
	
	

# 更新与该工步相关的装配资源的显示
func update_ToolBox_list():
	ToolBoxItemList.clear()
	for i in range(toolBox.size()):
		var item = toolBox[i]
		ToolBoxItemList.add_item(item.name)
		ToolBoxItemList.set_item_metadata(i, item)
	
# 更新与该工步相关的装配对象的显示
func update_ModelBox_list():
	$ListAndButton/therbligsConnectObjectWin.show_assembly_object_tree()




func _ready():
	initData()
	update_Therblig_list()
#	update_ModelBox_list()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 为该工步添加动素 —— 弹出选择类型窗口
func add_Therblig_select_type():
	$ListAndButton/SelectType.visible = true
	$ListAndButton/SelectType/VBoxContainer/HBoxContainer/type.select(-1)
	


# 确认信号——为该工步添加动素 —— 确认选择类型后调用
func confirm_select_type():
	var type = $"ListAndButton/SelectType/VBoxContainer/HBoxContainer/type".selected
	if type == TherbligType.camera:
		$"ListAndButton/AddCameraTb".visible = true
		$"ListAndButton/AddCameraTb".title = "添加动素"
		
		$ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.text = ""
		$ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.text = ""
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.text = ""
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.text = ""
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.text = ""
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.text = ""
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.text = ""
		$ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.text = ""
		
		$ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.editable = true
	
	elif type == TherbligType.model:
		$"ListAndButton/AddModelTb".visible = true
		$"ListAndButton/AddModelTb".title = "添加动素"
		$ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.text = ""
		$ListAndButton/AddModelTb/VBoxContainer/Model/ModelEdit.text = ""
		
		$ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/Model/bound.disabled = false
	
	elif type == TherbligType.workstep:
		$"ListAndButton/AddWorkstepTb".visible = true
		$"ListAndButton/AddWorkstepTb".title = "添加动素"
		
		$ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.text = ""
		$ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.select(-1)
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text = ""
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text = ""
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text = ""
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text = ""
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text = ""
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text = ""
		$ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.text = ""
		
		$ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.disabled = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.editable = true
	
	elif type == TherbligType.tool:
		$"ListAndButton/AddToolTb".visible = true
		$"ListAndButton/AddToolTb".title = "添加动素"
		
		$ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.text = ""
		$ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.text = ""
		$ListAndButton/AddToolTb/VBoxContainer/Tool/toolEdit.text = ""
		
		$ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.editable = true
		$ListAndButton/AddToolTb/VBoxContainer/Tool/bound.disabled = false

# 相机动素-确认信号——确认动素信息
func confirm_cameratb():
	if $ListAndButton/AddCameraTb.title == "添加动素":
		if !WorkStep_to_therblig.has(current_id):
			WorkStep_to_therblig[current_id] = []
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = CameraTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.camera
		newItem.priority = int($ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.startpos.x = float($ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.text)
		newItem.startpos.y = float($ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.text)
		newItem.startpos.z = float($ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.text)
		newItem.endpos.x = float($ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.text)
		newItem.endpos.y = float($ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.text)
		newItem.endpos.z = float($ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.text)
		newItem.time = float($ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.text)
		cur_tb_list.append(newItem)
		update_Therblig_list()
		TbSceneInstance.change_model(newItem)
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.startpos.x = float($ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.text)
	list_node.startpos.y = float($ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.text)
	list_node.startpos.z = float($ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.text)
	list_node.endpos.x = float($ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.text)
	list_node.endpos.y = float($ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.text)
	list_node.endpos.z = float($ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.text)
	list_node.time = float($ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.text)
	update_Therblig_list()
	TbSceneInstance.change_model(list_node)



# 点击按钮信号
func click_bound_to_tool():
	$ListAndButton/AddToolTb/SelectTool.visible = true
	# 更新SelectTool的ItemList
	update_ToolBox_list()
	
	
# 确认信号——确认选择装配资源信息
func confirm_bound_to_tool():
	var idx = ToolBoxItemList.get_selected_items()[0]
	selected_toolID = idx
	$ListAndButton/AddToolTb/VBoxContainer/Tool/toolEdit.text = ToolBoxItemList.get_item_text(idx)
	return


# 确认信号——确认工具动素信息
func confirm_tooltb():
	if $ListAndButton/AddToolTb.title == "添加动素":
		if !WorkStep_to_therblig.has(current_id):
			WorkStep_to_therblig[current_id] = []
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = ToolTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.tool
		newItem.priority = int($ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.time = float($ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.text)
		newItem.toolID = selected_toolID
		cur_tb_list.append(newItem)
		update_Therblig_list()
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.time = float($ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.text)
	list_node.toolID = selected_toolID
	list_node.model = null
	update_Therblig_list()


# -------------------- 工步动素 ----------------------------
# 确认信号——确认动素信息
func confirm_worksteptb():
	if $ListAndButton/AddWorkstepTb.title == "添加动素":
		
		if !WorkStep_to_therblig.has(current_id):
			WorkStep_to_therblig[current_id] = []
	
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = WorkstepTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.workstep
		newItem.priority = int($ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.signtype = $ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.selected
		newItem.startpos.x = float($ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text)
		newItem.startpos.y = float($ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text)
		newItem.startpos.z = float($ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text)
		newItem.endpos.x = float($ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text)
		newItem.endpos.y = float($ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text)
		newItem.endpos.z = float($ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text)
		newItem.time = float($ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.text)
		cur_tb_list.append(newItem)
		update_Therblig_list()
		TbSceneInstance.change_model(newItem)
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.signtype = $ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.selected
	list_node.startpos.x = float($ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text)
	list_node.startpos.y = float($ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text)
	list_node.startpos.z = float($ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text)
	list_node.endpos.x = float($ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text)
	list_node.endpos.y = float($ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text)
	list_node.endpos.z = float($ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text)
	list_node.time = float($ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.text)
	update_Therblig_list()
	TbSceneInstance.change_model(list_node)


# #################################################
# ----------------模型动素-----------------------
# #################################################
# 点击按钮信号
func click_bound_to_model():
	$ListAndButton/therbligsConnectObjectWin/SelectModel.visible = true
#	$ListAndButton/AddModelTb/SelectModel.visible = true
	# 更新SelectModel的ItemList
	update_ModelBox_list()
	
	
# 确认信号——确认选择装配对象信息
func confirm_bound_to_model():
	print("绑定模型")
	var select_tree_node = assmblyObjectTree.get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		return
	
	selected_modelID = list_node.id
	print(list_node)
	print(list_node.name)
	$ListAndButton/AddModelTb/VBoxContainer/Model/ModelEdit.text = list_node.name
	return


# 确认信号——确认模型动素信息
func confirm_modeltb():
	if $ListAndButton/AddModelTb.title == "添加动素":
		if !WorkStep_to_therblig.has(current_id):
			WorkStep_to_therblig[current_id] = []
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = ModelTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.model
		newItem.priority = int($ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.startpos.x = float($ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.text)
		newItem.startpos.y = float($ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.text)
		newItem.startpos.z = float($ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.text)
		newItem.endpos.x = float($ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.text)
		newItem.endpos.y = float($ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.text)
		newItem.endpos.z = float($ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.text)
		newItem.time = float($ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.text)
		newItem.modelID = selected_modelID
		
		cur_tb_list.append(newItem)
		update_Therblig_list()
		
		TbSceneInstance.change_model(newItem)
		
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.startpos.x = float($ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.text)
	list_node.startpos.y = float($ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.text)
	list_node.startpos.z = float($ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.text)
	list_node.endpos.x = float($ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.text)
	list_node.endpos.y = float($ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.text)
	list_node.endpos.z = float($ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.text)
	list_node.time = float($ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.text)
	list_node.modelID = selected_modelID
	list_node.model = null
	update_Therblig_list()
	TbSceneInstance.change_model(list_node)



# ---------------ItemLits相关 -------------------

# 选中动素时显示到窗口
func _on_item_selected(index):
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	TbSceneInstance.change_model(list_node)


# #################################################
# ----------------右键悬浮框-----------------------
# #################################################
func play_anima():
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	TbSceneInstance.play_tb_anima(list_node)
	close_assTbPopWin()

# 查看动素信息
func check_tb_info():
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return

	if list_node.type == TherbligType.camera:
		$"ListAndButton/AddCameraTb".visible = true
		$"ListAndButton/AddCameraTb".title = "查看动素信息"
		$ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.editable = false
		$ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.editable = false
	
	elif list_node.type == TherbligType.model:
		$"ListAndButton/AddModelTb".visible = true
		$"ListAndButton/AddModelTb".title = "查看动素信息"
		$ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		var temp_model = find_model(list_node.modelID)
		$ListAndButton/AddModelTb/VBoxContainer/Model/ModelEdit.text = temp_model.name
		selected_modelID = list_node.modelID
		
		$ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.editable = false
		$ListAndButton/AddModelTb/VBoxContainer/Model/bound.disabled = true
		
	elif list_node.type == TherbligType.workstep:
		$"ListAndButton/AddWorkstepTb".visible = true
		$"ListAndButton/AddWorkstepTb".title = "查看动素信息"
		$ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.select(list_node.signtype)
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.disabled = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.editable = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.editable = false
		
	elif list_node.type == TherbligType.tool:
		$"ListAndButton/AddToolTb".visible = true
		$"ListAndButton/AddToolTb".title = "查看动素信息"
		$ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.text = list_node.name		
		$ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		#$ListAndButton/AddToolTb/VBoxContainer/Tool/toolEdit.text = ToolBoxItemList.get_item_text(list_node.model)
		var temp_tool = find_tool(list_node.toolID)
		$ListAndButton/AddToolTb/VBoxContainer/Tool/toolEdit.text = temp_tool.name
		selected_toolID = list_node.toolID
		
		$ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.editable = false
		$ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.editable = false
		$ListAndButton/AddToolTb/VBoxContainer/Tool/bound.disabled = true
	
	print(list_node)
	close_assTbPopWin()


# 编辑动素信息
func edit_tb_info():
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return

	
	if list_node.type == TherbligType.camera:
		$"ListAndButton/AddCameraTb".visible = true
		$"ListAndButton/AddCameraTb".title = "编辑动素信息"
		$ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$ListAndButton/AddCameraTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startxEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startyEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/StartPos/startzEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endxEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endyEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/EndPos/endzEdit.editable = true
		$ListAndButton/AddCameraTb/VBoxContainer/Time/timeEdit.editable = true
	
	elif list_node.type == TherbligType.model:
		$"ListAndButton/AddModelTb".visible = true
		$"ListAndButton/AddModelTb".title = "编辑动素信息"
		$ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		var temp_model = find_model(list_node.modelID)
		print(list_node.modelID)
		selected_modelID = list_node.modelID
		$ListAndButton/AddModelTb/VBoxContainer/Model/ModelEdit.text = temp_model.name
		
		$ListAndButton/AddModelTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startxEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startyEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/StartPos/startzEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endxEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endyEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/EndPos/endzEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/Time/timeEdit.editable = true
		$ListAndButton/AddModelTb/VBoxContainer/Model/bound.disabled = false
		
	elif list_node.type == TherbligType.workstep:
		$"ListAndButton/AddWorkstepTb".visible = true
		$"ListAndButton/AddWorkstepTb".title = "编辑动素信息"
		$ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.select(list_node.signtype)
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$ListAndButton/AddWorkstepTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/Sign/SignEdit.disabled = false
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.editable = true
		$ListAndButton/AddWorkstepTb/VBoxContainer/Time/timeEdit.editable = true
	elif list_node.type == TherbligType.tool:
		$"ListAndButton/AddToolTb".visible = true
		$"ListAndButton/AddToolTb".title = "编辑动素信息"
		$ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		$ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		#$ListAndButton/AddToolTb/VBoxContainer/Tool/toolEdit.text = ToolBoxItemList.get_item_text(list_node.model)
		var temp_tool = find_tool(list_node.toolID)
		selected_toolID = list_node.toolID
		$ListAndButton/AddToolTb/VBoxContainer/Tool/toolEdit.text = temp_tool.name
		
		$ListAndButton/AddToolTb/VBoxContainer/Name/NameEdit.editable = true
		$ListAndButton/AddToolTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$ListAndButton/AddToolTb/VBoxContainer/Time/timeEdit.editable = true
		$ListAndButton/AddToolTb/VBoxContainer/Tool/bound.disabled = false
		
	close_assTbPopWin()

# 删除动素
func delete_assembly_tb():
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	var index = 0
	var cur_tb_list = WorkStep_to_therblig[current_id]
	for varAssObj in cur_tb_list:
		if varAssObj.id == list_node.id:
			break
		index = index + 1
	cur_tb_list.remove_at(index)
	#关闭右键编辑浮窗并重建树
	close_assTbPopWin()
	update_Therblig_list()
	TbSceneInstance.clear_model()




	
#右键打开小编辑浮窗
func _on_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_RIGHT:
		$"../../../SubViewport/tbScene".VR_therblig_assembly(TherbligItemList.get_item_metadata(TherbligItemList.get_selected_items()[0]))
		return
	$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.visible = true
	$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.position = at_position +self.global_position
	var window = DisplayServer. window_get_size()
	if $ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.position.y > window.y-$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.get_rect().size.y:
		$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.position.y = window.y-$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.get_rect().size.y
	

			
	# 如果该动素的类型不是“模型动素”，则禁用播放动画按钮
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
#	if list_node.type == TherbligType.model:
#		$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin/VBoxContainer/play.disabled = false
#	elif list_node.type == TherbligType.workstep:
#		$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin/VBoxContainer/play.disabled = false
#	else:
#		$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin/VBoxContainer/play.disabled = true

# 关闭右键悬浮窗接口
func close_assTbPopWin():
	$ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.visible = false



#点击右键编辑浮窗外侧区域关闭右键编辑浮窗
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var container = $ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.get_rect()
			container.position = $ListAndButton/ScrollContainer/HBoxContainer/ColorRect/assTbPopWin.global_position
			if container.has_point(event.position):
				return
			else:
				close_assTbPopWin()
				TherbligItemList.deselect_all()
				


# #################################################
# ----------------其他-----------------------
# #################################################
# 关闭动素管理界面
func close_tbMgr():
	get_parent().remove_child(self)
	if_exist = false
	TbSceneInstance.clear_model()



func find_model(idx):
	print("查找模型id：", idx)
	for m in $"../../../../../../../VSplitContainer/VBoxContainer2/TabContainer/产品管理/Tree".assemblyObjectList:
		if int(m.id) == int(idx):
			print(idx)
			return m

func find_tool(idx):
	for m in toolBox:
		if int(m.id) == int(idx):
			return m
