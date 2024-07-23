extends Tree

enum GONGYI_TYPE{GONGXU,GONGBU,GONGYI}
var gongyi = {}
var gongxu_list = []
var gongbu_list = []

var gongxu_idx:int = 0
var gongbu_idx:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initData()
	update_tree_UI()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_gongyi(gongyi_tmp):
	gongyi = gongyi_tmp
	gongxu_list = gongyi_tmp.gongxu_list
	gongbu_list = gongyi_tmp.gongbu_list
	
	var max:int = 0
	for item in gongxu_list:
		if item.id > max:
			max = item.id
	gongxu_idx = max +1
	max = 0
	
	for item in gongbu_list:
		if item.id > max:
			max = item.id
	gongbu_idx = max +1
	update_tree_UI()
	
func initData():
	gongyi.name = "装配工艺"
	gongyi.desc = "工艺的描述"
	gongyi.gongxu_list = gongxu_list
	gongyi.gongbu_list = gongbu_list
#	var gongxu1 = {}
#	gongxu1.name = "工序1"
#	gongxu1.id = 1
#	gongxu1.content = "工序1的工序内容"
#	gongxu1.demand = "工序1的技术要求"
#	gongxu1.time = 10
#
#	gongxu_list.push_back(gongxu1)
#
#	var gongxu2 = {}
#	gongxu2.name = "工序2"
#	gongxu2.id = 2
#	gongxu2.content = "工序2的工序内容"
#	gongxu2.demand = "工序2的技术要求"
#	gongxu2.time = 100
#
#	gongxu_list.push_back(gongxu2)
#
#	var gongxu3 = {}
#	gongxu3.name = "工序3"
#	gongxu3.id = 3
#	gongxu3.content = "工序3的工序内容"
#	gongxu3.demand = "工序3的技术要求"
#	gongxu3.time = 23
#
#	gongxu_list.push_back(gongxu3)
#
#	var gongxu4 = {}
#	gongxu4.name = "工序4"
#	gongxu4.id = 4
#	gongxu4.content = "工序4的工序内容"
#	gongxu4.demand = "工序4的技术要求"
#	gongxu4.time = 20
#	gongxu_list.push_back(gongxu4)
#
#
#	var gongbu1 = {}
#	gongbu1.id =1 
#	gongbu1.parent_id = 1
#	gongbu1.name = "工步1"
#	gongbu1.department = "工步1的装配部门"
#	gongbu1.demand = "工步1的装配要求"
#	gongbu1.time = 3
#	gongbu_list.push_back(gongbu1)
#
#	var gongbu2 = {}
#	gongbu2.id =2 
#	gongbu2.parent_id = 1
#	gongbu2.name = "工步2"
#	gongbu2.department = "工步2的装配部门"
#	gongbu2.demand = "工步2的装配要求"
#	gongbu2.time = 3
#	gongbu_list.push_back(gongbu2)
#
#	var gongbu3 = {}
#	gongbu3.id =3 
#	gongbu3.parent_id = 1
#	gongbu3.name = "工步3"
#	gongbu3.department = "工步3的装配部门"
#	gongbu3.demand = "工步3的装配要求"
#	gongbu3.time = 3
#	gongbu_list.push_back(gongbu3)
#
#	var gongbu4 = {}
#	gongbu4.id =4
#	gongbu4.parent_id = 2
#	gongbu4.name = "工步4"
#	gongbu4.department = "工步4的装配部门"
#	gongbu4.demand = "工步4的装配要求"
#	gongbu4.time = 3
#	gongbu_list.push_back(gongbu4)
#
#	var gongbu5 = {}
#	gongbu5.id =5
#	gongbu5.parent_id = 2
#	gongbu5.name = "工步5"
#	gongbu5.department = "工步5的装配部门"
#	gongbu5.demand = "工步5的装配要求"
#	gongbu5.time = 3
#	gongbu_list.push_back(gongbu5)
	
func update_tree_UI():
	clear()
	
	var tree = self
#	tree.set_column_title(0, "工艺管理")
#	tree.set_column_titles_visible(true)

	var root = tree.create_item()
	gongyi.type = GONGYI_TYPE.GONGYI
	root.set_text(0, gongyi.name)
	root.set_metadata(0,gongyi)
	root.set_custom_color(0,Color(0.7,0.5,0.2))


#	tree.set_hide_root(true)
	#生成后续节点
	for gongxu in gongxu_list:
		gongxu.type = GONGYI_TYPE.GONGXU
		var gongxu_node = root.create_child()
		gongxu_node.set_text(0,gongxu.name)
		gongxu_node.set_metadata(0,gongxu)
		gongxu_node.set_custom_color(0,Color(0.5,0.2,0.7))
		for gongbu in gongbu_list:
			if gongbu.parent_id == gongxu.id:
				gongbu.type = GONGYI_TYPE.GONGBU
				var gongbu_node = gongxu_node.create_child()
				gongbu_node.set_text(0,gongbu.name)
				gongbu_node.set_metadata(0,gongbu)
				gongbu_node.set_custom_color(0,Color(0.2,0.5,0.7))
	pass
#关闭右键编辑浮窗接口
func close_assObjPopWin():
	$AssGongyiPop.visible = false
	$AssGongyiPop.set_global_position(Vector2(-300, 0))
	$AssGongxuPop.visible = false
	$AssGongxuPop.set_global_position(Vector2(-300, 0))
	$AssGongbuPop.visible = false
	$AssGongbuPop.set_global_position(Vector2(-300, 0))




var selected_item = {}
func _on_item_mouse_selected(position, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		var item_meta = get_selected().get_metadata(0)
		if item_meta.type == GONGYI_TYPE.GONGYI:
			
			$AssGongyiPop.visible = true
			$AssGongyiPop.position = position +self.global_position
			var window = DisplayServer. window_get_size()
			if $AssGongyiPop.position.y > window.y-$AssGongyiPop.get_rect().size.y:
				$AssGongyiPop.position.y = window.y-$AssGongyiPop.get_rect().size.y
		if item_meta.type == GONGYI_TYPE.GONGXU:
			
			$AssGongxuPop.visible = true
			$AssGongxuPop.position = position +self.global_position
			var window = DisplayServer. window_get_size()
			if $AssGongxuPop.position.y > window.y-$AssGongxuPop.get_rect().size.y:
				$AssGongxuPop.position.y = window.y-$AssGongxuPop.get_rect().size.y
		if item_meta.type == GONGYI_TYPE.GONGBU:
			
			$AssGongbuPop.visible = true
			$AssGongbuPop.position = position +self.global_position
			var window = DisplayServer. window_get_size()
			if $AssGongbuPop.position.y > window.y-$AssGongbuPop.get_rect().size.y:
				$AssGongbuPop.position.y = window.y-$AssGongbuPop.get_rect().size.y
	else:
		var select_tree_node = get_selected()
		var list_node = select_tree_node.get_metadata(0)
		if list_node.type == GONGYI_TYPE.GONGBU:
			tbMgrInstance.current_id = int(list_node.id)
			tbMgrInstance.update_Therblig_list()
		else:
			tbMgrInstance.current_id = -1
			tbMgrInstance.update_Therblig_list()
		pass # Replace with function body.



func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if $AssGongyiPop.get_rect().has_point(event.position)or $AssGongbuPop.get_rect().has_point(event.position)or $AssGongxuPop.get_rect().has_point(event.position):
				return
			else:
				close_assObjPopWin()
				






func add_gongxu():
	$AddAssemblyGongxu.visible = true
	$AddAssemblyGongxu/VBoxContainer/name/LineEdit.text = ""
	$AddAssemblyGongxu/VBoxContainer/content/LineEdit.text = ""
	$AddAssemblyGongxu/VBoxContainer/demand/LineEdit.text = ""
	$AddAssemblyGongxu/VBoxContainer/time/LineEdit.text = ""
	close_assObjPopWin()
	pass # Replace with function body.


func add_gongbu():
	$AddAssemblyGongbu.visible = true
	$AddAssemblyGongbu/VBoxContainer/name/LineEdit.text = ""
	$AddAssemblyGongbu/VBoxContainer/department/LineEdit.text = ""
	$AddAssemblyGongbu/VBoxContainer/demand/LineEdit.text = ""
	$AddAssemblyGongbu/VBoxContainer/time/LineEdit.text = ""
	close_assObjPopWin()
	pass # Replace with function body.
func add_gongxu_confirm():
	
	
	var gongxu = {}
	gongxu.id = gongxu_idx
	gongxu_idx = gongxu_idx + 1
	gongxu.name = $AddAssemblyGongxu/VBoxContainer/name/LineEdit.text
	gongxu.content = $AddAssemblyGongxu/VBoxContainer/content/LineEdit.text
	gongxu.demand = $AddAssemblyGongxu/VBoxContainer/demand/LineEdit.text
	gongxu.time = int($AddAssemblyGongxu/VBoxContainer/time/LineEdit.text)
	gongxu_list.push_back(gongxu)
	update_tree_UI()
	pass # Replace with function body.

func add_assembly_gongbu_confirmed():
	var item_meta = get_selected().get_metadata(0)
	var gongbu ={}
	gongbu.id = gongbu_idx
	gongbu_idx = gongbu_idx + 1
	gongbu.parent_id = item_meta.id
	gongbu.name = $AddAssemblyGongbu/VBoxContainer/name/LineEdit.text
	gongbu.department = $AddAssemblyGongbu/VBoxContainer/department/LineEdit.text
	gongbu.demand = $AddAssemblyGongbu/VBoxContainer/demand/LineEdit.text
	gongbu.time = int($AddAssemblyGongbu/VBoxContainer/time/LineEdit.text)
	gongbu_list.push_back(gongbu)
	update_tree_UI()
	pass # Replace with function body.



func show_gongyi():
	var item = get_selected()
	var meta = item.get_metadata(0)
	$ShowAssemblyGongyi.visible = true
	$ShowAssemblyGongyi/VBoxContainer/name/LineEdit.text = meta.name
	$ShowAssemblyGongyi/VBoxContainer/desc/LineEdit.text = meta.desc
	close_assObjPopWin()
	pass # Replace with function body.

func show_gongxu():
	var item = get_selected()
	var meta = item.get_metadata(0)
	$ShowAssemblyGongxu.visible = true
	$ShowAssemblyGongxu/VBoxContainer/name/LineEdit.text = meta.name
	$ShowAssemblyGongxu/VBoxContainer/content/LineEdit.text = meta.content
	$ShowAssemblyGongxu/VBoxContainer/demand/LineEdit.text = meta.demand
	$ShowAssemblyGongxu/VBoxContainer/time/LineEdit.text = str(meta.time)
	close_assObjPopWin()
	pass # Replace with function body.

func show_gongbu():
	var item = get_selected()
	var meta = item.get_metadata(0)
	$ShowAssemblyGongbu.visible = true
	$ShowAssemblyGongbu/VBoxContainer/name/LineEdit.text = meta.name
	$ShowAssemblyGongbu/VBoxContainer/department/LineEdit.text = meta.department
	$ShowAssemblyGongbu/VBoxContainer/demand/LineEdit.text = meta.demand
	$ShowAssemblyGongbu/VBoxContainer/time/LineEdit.text = str(meta.time)
	close_assObjPopWin()
	pass # Replace with function body.



func delete_gongxu():
	var item = get_selected()
	var meta = item.get_metadata(0)
	var i:int = 0
	while i < gongxu_list.size():
		var temp = gongxu_list[i]
		if temp.id == meta.id:
			gongxu_list.remove_at(i)
			i-=1
		i+= 1
	i =0 
	while i < gongbu_list.size():
		var temp = gongbu_list[i]
		if temp.parent_id == meta.id:
			gongbu_list.remove_at(i)
			i-=1
		i+= 1
	update_tree_UI()
	close_assObjPopWin()
	pass # Replace with function body.
func delete_gongbu():
	var item = get_selected()
	var meta = item.get_metadata(0)
	var i:int = 0
	while i < gongbu_list.size():
		var temp = gongbu_list[i]
		if temp.id == meta.id:
			gongbu_list.remove_at(i)
			i-=1
		i+= 1
	update_tree_UI()
	close_assObjPopWin()
	pass # Replace with function body.


func edit_assembly_gongxu_confirmed():
	var item = get_selected()
	var meta = item.get_metadata(0)
	var gongxu = {}
	
	gongxu.name = $EditAssemblyGongxu/VBoxContainer/name/LineEdit.text
	gongxu.id = meta.id
	gongxu.content = $EditAssemblyGongxu/VBoxContainer/content/LineEdit.text
	gongxu.demand = $EditAssemblyGongxu/VBoxContainer/demand/LineEdit.text
	gongxu.time = str($EditAssemblyGongxu/VBoxContainer/time/LineEdit.text)
	
	for i in range(gongxu_list.size()):
		var tmp = gongxu_list[i]
		if tmp.id == gongxu.id:
			gongxu_list[i] = gongxu
	update_tree_UI()
	pass # Replace with function body.


func edit_assembly_gongbu_confirmed():
	var item = get_selected()
	var meta = item.get_metadata(0)
	var gongbu = {}
	
	gongbu.name = $EditAssemblyGongbu/VBoxContainer/name/LineEdit.text
	gongbu.id = meta.id
	gongbu.department = $EditAssemblyGongbu/VBoxContainer/department/LineEdit.text
	gongbu.demand = $EditAssemblyGongbu/VBoxContainer/demand/LineEdit.text
	gongbu.time = str($EditAssemblyGongbu/VBoxContainer/time/LineEdit.text)
	gongbu.parent_id = meta.parent_id
	for i in range(gongbu_list.size()):
		var tmp = gongbu_list[i]
		if tmp.id == gongbu.id:
			gongbu_list[i] = gongbu
	update_tree_UI()
	pass # Replace with function body.


func edit_assembly_gongyi_confirmed():
	var item = get_selected()
	var meta = item.get_metadata(0)
	gongyi.name = $EditAssemblyGongyi/VBoxContainer/name/LineEdit.text
	gongyi.desc = $EditAssemblyGongyi/VBoxContainer/desc/LineEdit.text
	update_tree_UI()
	
	pass # Replace with function body.




func edit_gongyi():
	var item = get_selected()
	var meta = item.get_metadata(0)
	$EditAssemblyGongyi.visible = true
	$EditAssemblyGongyi/VBoxContainer/name/LineEdit.text = meta.name
	$EditAssemblyGongyi/VBoxContainer/desc/LineEdit.text = meta.desc
	close_assObjPopWin()
	pass # Replace with function body.




func edit_gongxu():
	var item = get_selected()
	var meta = item.get_metadata(0)
	$EditAssemblyGongxu.visible = true
	$EditAssemblyGongxu/VBoxContainer/name/LineEdit.text = meta.name
	$EditAssemblyGongxu/VBoxContainer/content/LineEdit.text = meta.content
	$EditAssemblyGongxu/VBoxContainer/demand/LineEdit.text = meta.demand
	$EditAssemblyGongxu/VBoxContainer/time/LineEdit.text = str(meta.time)
	close_assObjPopWin()
	pass # Replace with function body.








func edit_gongbu():
	var item = get_selected()
	var meta = item.get_metadata(0)
	$EditAssemblyGongbu.visible = true
	$EditAssemblyGongbu/VBoxContainer/name/LineEdit.text = meta.name
	$EditAssemblyGongbu/VBoxContainer/department/LineEdit.text = meta.department
	$EditAssemblyGongbu/VBoxContainer/demand/LineEdit.text = meta.demand
	$EditAssemblyGongbu/VBoxContainer/time/LineEdit.text = str(meta.time)
	close_assObjPopWin()
	pass # Replace with function body.
	
	
	
# ------------------------- 动素部分 -------------------------

@onready var tbMgrInstance =$"../../../../../HSplitContainer/VBoxContainer/TabContainer/动素显示/VSplitContainer/TabContainer/动素管理"


	
# 打开动素管理界面
func add_dongsu():
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		return
	tbMgrInstance.current_id = list_node.id
	tbMgrInstance.add_Therblig_select_type()
	tbMgrInstance.update_Therblig_list()
	close_assObjPopWin()
	



func play_gongbu_dongsu():
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		return
	var WorkStepList = gongbu_list
	var WorkStep_to_therblig = $"../../../../../HSplitContainer/VBoxContainer/TabContainer/动素显示/VSplitContainer/TabContainer/动素管理".WorkStep_to_therblig
	tbMgrInstance.TbSceneInstance.play_workstep_anima(list_node, WorkStepList, WorkStep_to_therblig)
	close_assObjPopWin()
