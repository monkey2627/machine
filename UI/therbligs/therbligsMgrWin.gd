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
	# 绑定的装配资源，这里是个int，以后可能要改成装配资源的数据结构
	var boundtool:int
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


class ModelTb:
	var name:String
	var type:int
	var id:int
	var priority:int = 0
	
	var startpos:Vector3
	var endpos:Vector3
	var time:float
	# 绑定的装配对象，这里是个int，以后可能要改成装配资源的数据结构
	var model:int
	var anima:Tween


# 用于判断动素理界面是否存在
var if_exist = false

# 用于存储与该工步关联的装配资源，在点击"管理动素"时更新
var toolBox = ["工具1", "工具2", "工具3"]

# 用于存储与该工步关联的装配资源，在点击"管理动素"时更新
var modelBox = ["侧板1", "侧板2", "叶片1"]

# 用于记录临时的装配资源列表，在确认SelectTool时更新
var temp_toolbox = []
# 用于记录临时的装配对象列表，在确认SelectModel时更新
var temp_modelbox

# 用工步的id去索引该工步的动素list
var WorkStep_to_therblig = {}

# 表示当前查看的工步
var current_id = 1

# 表示现有的所有工步
var WorkStepList = []

# 相关UI
@onready var TherbligItemList = $"VBoxContainer/ScrollContainer/HBoxContainer/ItemList"

@onready var AddTherblig_SelectType = $"AddTherblig/SelectType"
@onready var ToolBoxItemList = $AddTherblig/AddToolTb/SelectTool/ItemList
@onready var ModelBoxItemList = $AddTherblig/AddModelTb/SelectModel/ItemList

# 动素显示窗口相关
var TbSceneInstance
var TbSceneInstance_TabContainer


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

	
# 更新动素列表的显示
func update_Therblig_list():
	# 如果该工步没有动素list，则为它创建个
	if WorkStep_to_therblig.has(current_id) == false:
		WorkStep_to_therblig[current_id] = []
	TbSceneInstance.WorkStep_to_therblig = WorkStep_to_therblig
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
		ToolBoxItemList.add_item(item)
		ToolBoxItemList.set_item_metadata(i, item)
	
# 更新与该工步相关的装配对象的显示
func update_ModelBox_list():
	ModelBoxItemList.clear()
	for i in range(modelBox.size()):
		var item = modelBox[i]
		ModelBoxItemList.add_item(item)
		ModelBoxItemList.set_item_metadata(i, item)
	



func _ready():
	initData()
	update_Therblig_list()
	update_ModelBox_list()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 为该工步添加动素 —— 弹出选择类型窗口
func add_Therblig_select_type():
	$"AddTherblig/SelectType".visible = true
	$"AddTherblig/SelectType/VBoxContainer/HBoxContainer/type".select(-1)
	
	
	

# 确认信号——为该工步添加动素 —— 确认选择类型后调用
func confirm_select_type():
	var type = $"AddTherblig/SelectType/VBoxContainer/HBoxContainer/type".selected
	if type == TherbligType.camera:
		$"AddTherblig/AddCameraTb".visible = true
		$"AddTherblig/AddCameraTb".title = "添加动素"
		
		$AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.text = ""
		$AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.text = ""
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.text = ""
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.text = ""
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.text = ""
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.text = ""
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.text = ""
		$AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.text = ""
		
		$AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.editable = true
	
	elif type == TherbligType.model:
		$"AddTherblig/AddModelTb".visible = true
		$"AddTherblig/AddModelTb".title = "添加动素"
#		temp_modelbox = []
		$AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.text = ""
		$AddTherblig/AddModelTb/VBoxContainer/Model/ModelEdit.text = ""
		
		$AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/Model/bound.disabled = false
	
	elif type == TherbligType.workstep:
		$"AddTherblig/AddWorkstepTb".visible = true
		$"AddTherblig/AddWorkstepTb".title = "添加动素"
		
		$AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.text = ""
		$AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.select(-1)
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text = ""
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text = ""
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text = ""
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text = ""
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text = ""
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text = ""
		$AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.text = ""
		
		$AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.disabled = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.editable = true
	
	elif type == TherbligType.tool:
		$"AddTherblig/AddToolTb".visible = true
		$"AddTherblig/AddToolTb".title = "添加动素"
		
		$AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.text = ""
		$AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.value = 0
		$AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.text = ""
		$AddTherblig/AddToolTb/VBoxContainer/Tool/toolEdit.text = ""
		
		$AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.editable = true
		$AddTherblig/AddToolTb/VBoxContainer/Tool/bound.disabled = false

# 相机动素-确认信号——确认动素信息
func confirm_cameratb():
	if $AddTherblig/AddCameraTb.title == "添加动素":
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = CameraTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.camera
		newItem.priority = int($AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.startpos.x = float($AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.text)
		newItem.startpos.y = float($AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.text)
		newItem.startpos.z = float($AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.text)
		newItem.endpos.x = float($AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.text)
		newItem.endpos.y = float($AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.text)
		newItem.endpos.z = float($AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.text)
		newItem.time = float($AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.text)
		cur_tb_list.append(newItem)
		update_Therblig_list()
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.startpos.x = float($AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.text)
	list_node.startpos.y = float($AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.text)
	list_node.startpos.z = float($AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.text)
	list_node.endpos.x = float($AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.text)
	list_node.endpos.y = float($AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.text)
	list_node.endpos.z = float($AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.text)
	list_node.time = float($AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.text)
	update_Therblig_list()



# 点击按钮信号
func click_bound_to_tool():
	$AddTherblig/AddToolTb/SelectTool.visible = true
	# 更新SelectTool的ItemList
	update_ToolBox_list()
	
	
# 确认信号——确认选择装配资源信息
func confirm_bound_to_tool():
	temp_toolbox = ToolBoxItemList.get_selected_items()
	var idx = temp_toolbox[0]
	$AddTherblig/AddToolTb/VBoxContainer/Tool/toolEdit.text = ToolBoxItemList.get_item_text(idx)
	return


# 确认信号——确认工具动素信息
func confirm_tooltb():
	if $AddTherblig/AddToolTb.title == "添加动素":
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = ToolTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.tool
		newItem.priority = int($AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.time = float($AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.text)
		newItem.boundtool = temp_toolbox[0]
		cur_tb_list.append(newItem)
		update_Therblig_list()
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.time = float($AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.text)
	list_node.boundtool = temp_toolbox[0]
	update_Therblig_list()


# -------------------- 工步动素 ----------------------------
# 确认信号——确认动素信息
func confirm_worksteptb():
	if $AddTherblig/AddWorkstepTb.title == "添加动素":
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = WorkstepTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.workstep
		newItem.priority = int($AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.signtype = $AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.selected
		newItem.startpos.x = float($AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text)
		newItem.startpos.y = float($AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text)
		newItem.startpos.z = float($AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text)
		newItem.endpos.x = float($AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text)
		newItem.endpos.y = float($AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text)
		newItem.endpos.z = float($AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text)
		newItem.time = float($AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.text)
		cur_tb_list.append(newItem)
		update_Therblig_list()
		TbSceneInstance.change_tb_3Dinfo(newItem)
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.signtype = $AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.selected
	list_node.startpos.x = float($AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text)
	list_node.startpos.y = float($AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text)
	list_node.startpos.z = float($AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text)
	list_node.endpos.x = float($AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text)
	list_node.endpos.y = float($AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text)
	list_node.endpos.z = float($AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text)
	list_node.time = float($AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.text)
	update_Therblig_list()
	TbSceneInstance.change_tb_3Dinfo(list_node)


# #################################################
# ----------------模型动素-----------------------
# #################################################
# 点击按钮信号
func click_bound_to_model():
	$AddTherblig/AddModelTb/SelectModel.visible = true
	# 更新SelectModel的ItemList
	update_ModelBox_list()
	
	
# 确认信号——确认选择装配对象信息
func confirm_bound_to_model():
	temp_modelbox = ModelBoxItemList.get_selected_items()[0]
	$AddTherblig/AddModelTb/VBoxContainer/Model/ModelEdit.text = ModelBoxItemList.get_item_text(temp_modelbox)
	return


# 确认信号——确认模型动素信息
func confirm_modeltb():
	if $AddTherblig/AddModelTb.title == "添加动素":
		var cur_tb_list = WorkStep_to_therblig[current_id]
		var newItem = ModelTb.new()
		newItem.id = idx
		idx = idx + 1
		newItem.name = $AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.text
		if newItem.name == "":
			newItem.name = "未命名动素"
		newItem.type = TherbligType.model
		newItem.priority = int($AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.value)
		newItem.startpos.x = float($AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.text)
		newItem.startpos.y = float($AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.text)
		newItem.startpos.z = float($AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.text)
		newItem.endpos.x = float($AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.text)
		newItem.endpos.y = float($AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.text)
		newItem.endpos.z = float($AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.text)
		newItem.time = float($AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.text)
		newItem.model = temp_modelbox
		cur_tb_list.append(newItem)
		update_Therblig_list()
		
		TbSceneInstance.change_tb_3Dinfo(newItem)
		
		return
	# 修改节点信息
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return
	list_node.name = $AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.text
	list_node.priority = int($AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.value)
	list_node.startpos.x = float($AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.text)
	list_node.startpos.y = float($AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.text)
	list_node.startpos.z = float($AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.text)
	list_node.endpos.x = float($AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.text)
	list_node.endpos.y = float($AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.text)
	list_node.endpos.z = float($AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.text)
	list_node.time = float($AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.text)
	list_node.model = temp_modelbox
	update_Therblig_list()
	TbSceneInstance.change_tb_3Dinfo(list_node)



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
	if list_node.type == TherbligType.model or list_node.type == TherbligType.workstep:
		TbSceneInstance.play_tb_anima(list_node)
		TbSceneInstance_TabContainer.set_current_tab(0)
	close_assTbPopWin()

# 查看动素信息
func check_tb_info():
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return

	if list_node.type == TherbligType.camera:
		$"AddTherblig/AddCameraTb".visible = true
		$"AddTherblig/AddCameraTb".title = "查看动素信息"
		$AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.editable = false
		$AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.editable = false
	
	elif list_node.type == TherbligType.model:
		$"AddTherblig/AddModelTb".visible = true
		$"AddTherblig/AddModelTb".title = "查看动素信息"
		temp_modelbox = list_node.model
		$AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		print("查看信息：", temp_modelbox, ModelBoxItemList.get_item_text(list_node.model))
		$AddTherblig/AddModelTb/VBoxContainer/Model/ModelEdit.text = ModelBoxItemList.get_item_text(list_node.model)
		
		$AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.editable = false
		$AddTherblig/AddModelTb/VBoxContainer/Model/bound.disabled = true
		
	elif list_node.type == TherbligType.workstep:
		$"AddTherblig/AddWorkstepTb".visible = true
		$"AddTherblig/AddWorkstepTb".title = "查看动素信息"
		$AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.select(list_node.signtype)
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.disabled = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.editable = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.editable = false
		
	elif list_node.type == TherbligType.tool:
		$"AddTherblig/AddToolTb".visible = true
		$"AddTherblig/AddToolTb".title = "查看动素信息"
		$AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.text = list_node.name		
		$AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		$AddTherblig/AddToolTb/VBoxContainer/Tool/toolEdit.text = ToolBoxItemList.get_item_text(list_node.boundtool)
		
		$AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.editable = false
		$AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.editable = false
		$AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.editable = false
		$AddTherblig/AddToolTb/VBoxContainer/Tool/bound.disabled = true
	
	print(list_node)
	close_assTbPopWin()


# 编辑动素信息
func edit_tb_info():
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node == null:
		return

	
	if list_node.type == TherbligType.camera:
		$"AddTherblig/AddCameraTb".visible = true
		$"AddTherblig/AddCameraTb".title = "编辑动素信息"
		$AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$AddTherblig/AddCameraTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startxEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startyEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/StartPos/startzEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endxEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endyEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/EndPos/endzEdit.editable = true
		$AddTherblig/AddCameraTb/VBoxContainer/Time/timeEdit.editable = true
	
	elif list_node.type == TherbligType.model:
		$"AddTherblig/AddModelTb".visible = true
		$"AddTherblig/AddModelTb".title = "编辑动素信息"
		$AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		$AddTherblig/AddModelTb/VBoxContainer/Model/ModelEdit.text = ModelBoxItemList.get_item_text(list_node.model)
		temp_modelbox = list_node.model
		
		$AddTherblig/AddModelTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startxEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startyEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/StartPos/startzEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endxEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endyEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/EndPos/endzEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/Time/timeEdit.editable = true
		$AddTherblig/AddModelTb/VBoxContainer/Model/bound.disabled = false
		
	elif list_node.type == TherbligType.workstep:
		$"AddTherblig/AddWorkstepTb".visible = true
		$"AddTherblig/AddWorkstepTb".title = "编辑动素信息"
		$AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.select(list_node.signtype)
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.text = str(list_node.startpos.x)
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.text = str(list_node.startpos.y)
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.text = str(list_node.startpos.z)
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.text = str(list_node.endpos.x)
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.text = str(list_node.endpos.y)
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.text = str(list_node.endpos.z)
		$AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		
		$AddTherblig/AddWorkstepTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/Sign/SignEdit.disabled = false
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startxEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startyEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/StartPos/startzEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endxEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endyEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/EndPos/endzEdit.editable = true
		$AddTherblig/AddWorkstepTb/VBoxContainer/Time/timeEdit.editable = true
	elif list_node.type == TherbligType.tool:
		$"AddTherblig/AddToolTb".visible = true
		$"AddTherblig/AddToolTb".title = "编辑动素信息"
		$AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.text = list_node.name
		$AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.value = list_node.priority
		$AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		$AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.text = str(list_node.time)
		$AddTherblig/AddToolTb/VBoxContainer/Tool/toolEdit.text = ToolBoxItemList.get_item_text(list_node.boundtool)
		
		
		$AddTherblig/AddToolTb/VBoxContainer/Name/NameEdit.editable = true
		$AddTherblig/AddToolTb/VBoxContainer/Priority/PriorityEdit.editable = true
		$AddTherblig/AddToolTb/VBoxContainer/Time/timeEdit.editable = true
		$AddTherblig/AddToolTb/VBoxContainer/Tool/bound.disabled = false
		
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
	if list_node.type == TherbligType.workstep:
		TbSceneInstance.delete_sign_model(list_node)



	
#右键打开小编辑浮窗
func _on_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_RIGHT:
		return
	$assTbPopWin.visible = true
	$assTbPopWin.position = at_position
	# 如果该动素的类型不是“模型动素”，则禁用播放动画按钮
	var select_tb = TherbligItemList.get_selected_items()[0]
	var list_node = TherbligItemList.get_item_metadata(select_tb)
	if list_node.type == TherbligType.model:
		$assTbPopWin/VBoxContainer/play.disabled = false
	elif list_node.type == TherbligType.workstep:
		$assTbPopWin/VBoxContainer/play.disabled = false
	else:
		$assTbPopWin/VBoxContainer/play.disabled = true

# 关闭右键悬浮窗接口
func close_assTbPopWin():
	$assTbPopWin.visible = false



#点击右键编辑浮窗外侧区域关闭右键编辑浮窗
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var container = $assTbPopWin.get_rect()
			container.position = $assTbPopWin.global_position
			if container.has_point(event.position):
				return
			else:
				close_assTbPopWin()


# #################################################
# ----------------其他-----------------------
# #################################################
# 关闭动素管理界面
func close_tbMgr():
	get_parent().remove_child(self)
	if_exist = false
	TbSceneInstance.clear_model()
