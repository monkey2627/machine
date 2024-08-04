extends ItemList

var model = []

@onready var assModelPopWin = $"../Control/assModelPopWin"

func _ready():
	initData()
	update_model_list()


#初始化数据
func initData():
	#var model1 = {}
	#model1.id = 0
	#model1.name = "装配对象模型1-扳手"
	#model1.path = "res://Model/AssemblyModel/新扳手.obj"
	#model.append(model1)
	
	var model2 = {}
	model2.id = 0
	model2.name = "装配对象模型1-书桌"
	model2.path = "res://Model/AssemblyModel/zzt5.glb"
	model.append(model2)
	pass
	
	
#更新模型列表的显示
func update_model_list():
	clear()
	var node = $"."
	
	for i in range(model.size()):
		var item = model[i]
		node.add_item(item.name)
		

#选中模型时显示到窗口中
func _on_item_selected(index):
	var show_model_path = model[index].path
	$"../../../../../../HSplitContainer/VBoxContainer/TabContainer/模型显示".show_model(show_model_path)


#右键打开小编辑浮窗
func _on_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_RIGHT:
		return
	assModelPopWin.visible = true
	assModelPopWin.position = at_position + $"..".global_position


#关闭右键悬浮窗接口
func close_assModelPopWin():
	assModelPopWin.visible = false


#点击右键编辑浮窗外侧区域关闭右键编辑浮窗
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var container = assModelPopWin.get_rect()
			container.position = assModelPopWin.global_position
			if container.has_point(event.position):
				return
			else:
				close_assModelPopWin()


#删除模型
func delete_assembly_omodel():
	var select_model = get_selected_items()
	print(select_model)
	var removeNum = 0
	for varAssModel in select_model:
		model.remove_at(varAssModel - removeNum)
		removeNum += 1
	print(model)
	close_assModelPopWin()
	update_model_list()
	
	
#编辑3D模型信息
func edit_assembly_model():
	var select_node = model[get_selected_items()[0]]
	
	$"../MessagePopWin".visible =true
	$"../MessagePopWin".title = "编辑3D模型信息"
	$"../MessagePopWin/VBoxContainer/HBoxContainer/LineEdit".text = select_node.name
	$"../MessagePopWin/VBoxContainer/HBoxContainer2/LineEdit".text = select_node.path
	
	$"../MessagePopWin/VBoxContainer/HBoxContainer/LineEdit".editable = true
	$"../MessagePopWin/VBoxContainer/HBoxContainer2/LineEdit".editable = true
	close_assModelPopWin()


#查看3D模型信息
func check_assembly_model():
	var select_node = model[get_selected_items()[0]]
	
	$"../MessagePopWin".visible =true
	$"../MessagePopWin".title = "查看3D模型信息"
	$"../MessagePopWin/VBoxContainer/HBoxContainer/LineEdit".text = select_node.name
	$"../MessagePopWin/VBoxContainer/HBoxContainer2/LineEdit".text = select_node.path
	
	$"../MessagePopWin/VBoxContainer/HBoxContainer/LineEdit".editable = false
	$"../MessagePopWin/VBoxContainer/HBoxContainer2/LineEdit".editable = false
	close_assModelPopWin()


#编辑3D模型信息确认接口
func confirm_edit_assembly_model():
	# 获取被选中的节点
	var select_node = model[get_selected_items()[0]]
#	# 添加新节点
#	# TODO
	# 修改节点信息
	if select_node == null:
		return
	
	select_node.name = $"../MessagePopWin/VBoxContainer/HBoxContainer/LineEdit".text
	select_node.path = $"../MessagePopWin/VBoxContainer/HBoxContainer2/LineEdit".text
	update_model_list()

