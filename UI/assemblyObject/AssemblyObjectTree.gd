extends Tree
#挂载在tree上
enum AssemblyObjType {zongZhuang, zongCheng, buJian}

var assemblyObjectList = []



# 获取数据并创建节点树
func _ready():
	pass



# 比较函数，用于在更新节点树之前对数据中的元素进行排序
func sort_ascending(a, b):
	if a.tree_depth < b.tree_depth:
		return true
	if a.tree_depth == b.tree_depth and a.tree_index < b.tree_index:
		return true
	return false

func set_assembly_objects(assembly_objects):
	assemblyObjectList = assembly_objects
	update_assembly_object_tree()
#	print(assemblyObjectList)
# 更新节点树
func update_assembly_object_tree():
	clear()
	#对元素进行排序，保证父节点在前面生成
	assemblyObjectList.sort_custom(sort_ascending)
	#更新深度信息
	for varAssObj in assemblyObjectList:
		if varAssObj.parent_id == 0:
			varAssObj.tree_depth = 1
		else:
			for vvarAssObj in assemblyObjectList:
				if vvarAssObj.id == varAssObj.parent_id:
					varAssObj.tree_depth = vvarAssObj.tree_depth + 1
					break
	assemblyObjectList.sort_custom(sort_ascending)
	#生成根节点
	var tree = self
	tree.set_column_title(0, "装配对象")
	tree.set_column_titles_visible(true)
	var root = tree.create_item()
	var product = $"../../../../../../../..".product
	root.set_text(0, product.name)
#	tree.set_hide_root(true)
	#生成后续节点
	for varObj in assemblyObjectList:
		var parent_node = root
		if varObj.parent_id == 0:
			parent_node = root
		else:
			for vvarObj in assemblyObjectList:
				if vvarObj.id == varObj.parent_id:
					parent_node = vvarObj.node
					break
			if parent_node == root:
				print("Error: can not find the father node")
		#构建树节点	
		varObj.node = tree.create_item(parent_node)
		varObj.node.set_text(0, varObj.name)
		varObj.node.set_metadata(0, varObj)




func _on_item_selected():
	if assemblyObjectList.size() == 0:
		return
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	$"../../../../../HSplitContainer/VBoxContainer/TabContainer/模型显示".show_assembly_obj(list_node)
	pass


#右键打开小编辑浮窗
func _on_item_mouse_selected(position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_RIGHT:
		return
	$assObjPopWin.visible = true
	$assObjPopWin.position = position


#点击右键编辑浮窗外侧区域关闭右键编辑浮窗
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if $assObjPopWin.get_rect().has_point(event.position):
				return
			else:
				close_assObjPopWin()


#关闭右键编辑浮窗接口
func close_assObjPopWin():
	$assObjPopWin.visible = false
	$assObjPopWin.set_global_position(Vector2(-300, 0))


#添加树节点接口
func add_assembly_object():
	$AddAssemblyObj.visible = true
	$AddAssemblyObj.title = "添加装配对象"
	
	$AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer6/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer7/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer9/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.text = ""
	$AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.text = ""
	
	$AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer6/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer7/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer9/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.editable = true
	close_assObjPopWin()


#复制树节点接口
func copy_assembly_object():
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		return
	var newItem = {}
	newItem.id = 1
	for varAssObj in assemblyObjectList:
		if newItem.id <= varAssObj.id:
			newItem.id = varAssObj.id + 1
#	newItem.id = assemblyObjectList[assemblyObjectList.size()-1].id + 1
	newItem.parent_id = list_node.parent_id
	newItem.tree_depth = list_node.tree_depth
	newItem.tree_index = 0
	for varAssObj in assemblyObjectList:
		if varAssObj.parent_id == newItem.parent_id and varAssObj.tree_index >= newItem.tree_index:
			newItem.tree_index = varAssObj.tree_index + 1
	newItem.name = list_node.name + "_copy"
	newItem.code = list_node.code
	newItem.design_user = list_node.design_user
	newItem.design_time = list_node.design_time
	newItem.tech_req = list_node.tech_req
	newItem.type = list_node.type
	newItem.is_reference = list_node.is_reference
	newItem.shape = list_node.shape
	newItem.color = list_node.color
	newItem.pos_matrix = list_node.pos_matrix
	newItem.benchmark = list_node.benchmark
	assemblyObjectList.append(newItem)
	update_assembly_object_tree()
	close_assObjPopWin()


#删除树节点接口
func delete_assembly_object():
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		return
	# 将子节点移交到上一层，修改父节点编号和节点顺序，深度推迟到update更新
	for varAssObj in assemblyObjectList:
		if varAssObj.parent_id == list_node.id:
			varAssObj.parent_id = list_node.parent_id
			varAssObj.tree_index = 0
			for vvarAssObj in assemblyObjectList:
				if varAssObj.parent_id == vvarAssObj.parent_id and varAssObj.tree_index <= vvarAssObj.tree_index:
					varAssObj.tree_index = vvarAssObj.tree_index + 1
	# 寻找对应元素
	var index = 0
	for varAssObj in assemblyObjectList:
		if varAssObj.id == list_node.id:
			break
		index = index + 1
	assemblyObjectList.remove_at(index)
	#关闭右键编辑浮窗并重建树
	close_assObjPopWin()
	update_assembly_object_tree()


#编辑树节点接口
func edit_assembly_objectd():
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		edit_assembly_product_object()
		return
	$AddAssemblyObj.visible =true
	$AddAssemblyObj.title = "查看装配对象信息"
	$AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.text = list_node.name
	$AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.text = list_node.code
	$AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.text = list_node.design_user
	$AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.text = list_node.design_time
	$AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.text = list_node.tech_req
	$AddAssemblyObj/VBoxContainer/HBoxContainer6/LineEdit.text = "总装"
	$AddAssemblyObj/VBoxContainer/HBoxContainer7/LineEdit.text = "true"
	$AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.text = list_node.shape
	$AddAssemblyObj/VBoxContainer/HBoxContainer9/LineEdit.text = "blue"
	$AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.text = list_node.pos_matrix
	$AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.text = list_node.benchmark
	
	$AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer6/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer7/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer9/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.editable = true
	$AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.editable = true
	close_assObjPopWin()


#查看树节点信息接口
func check_assembly_objectd():
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		check_assembly_product_object()
		return
	$AddAssemblyObj.visible =true
	$AddAssemblyObj.title = "编辑装配对象"
	$AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.text = list_node.name
	$AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.text = list_node.code
	$AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.text = list_node.design_user
	$AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.text = list_node.design_time
	$AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.text = list_node.tech_req
	$AddAssemblyObj/VBoxContainer/HBoxContainer6/LineEdit.text = "总装"
	$AddAssemblyObj/VBoxContainer/HBoxContainer7/LineEdit.text = "true"
	$AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.text = list_node.shape
	$AddAssemblyObj/VBoxContainer/HBoxContainer9/LineEdit.text = "blue"
	$AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.text = list_node.pos_matrix
	$AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.text = list_node.benchmark
	
	$AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer6/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer7/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer9/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.editable = false
	$AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.editable = false
	
#	print(list_node)
#	print("id:" + list_node.id + ", parent_id:" + String(list_node.parent_id) + ", tree_depth:" + String(list_node.tree_depth) + ", tree_index:" + String(list_node.tree_index))
	close_assObjPopWin()


#编辑树节点确认接口
func confirm_edit_assembly_object():
	# 获取被选中的节点
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	# 添加新节点
	if $AddAssemblyObj.title == "添加装配对象":
		var newItem = {}
		var parent_id_temp
		var tree_depth_temp
		if list_node == null:
			parent_id_temp = 0
			tree_depth_temp = 1
		else:
			parent_id_temp = list_node.id
			tree_depth_temp = list_node.tree_depth + 1
		# 新建编号
		newItem.id = 1
		for varAssObj in assemblyObjectList:
			if newItem.id <= varAssObj.id:
				newItem.id = varAssObj.id + 1
#		newItem.id = assemblyObjectList[assemblyObjectList.size()-1].id + 1
		newItem.parent_id = parent_id_temp
		newItem.tree_depth = tree_depth_temp
		newItem.tree_index = 0
		for varAssObj in assemblyObjectList:
			if varAssObj.parent_id == newItem.parent_id and varAssObj.tree_index >= newItem.tree_index:
				newItem.tree_index = varAssObj.tree_index + 1
		newItem.name = $AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.text
		if newItem.name == "":
			newItem.name = "未命名装配对象"
		newItem.code = $AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.text
		newItem.design_user = $AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.text
		newItem.design_time = $AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.text
		newItem.tech_req = $AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.text
		newItem.type = AssemblyObjType.buJian
		newItem.is_reference = true
		newItem.shape = $AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.text
		newItem.color = Color.BLUE
		newItem.pos_matrix = $AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.text
		newItem.benchmark = $AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.text
		assemblyObjectList.append(newItem)
		update_assembly_object_tree()
		return
	# 修改节点信息
	if list_node == null:
		return
	list_node.name = $AddAssemblyObj/VBoxContainer/HBoxContainer/LineEdit.text
	list_node.code = $AddAssemblyObj/VBoxContainer/HBoxContainer2/LineEdit.text
	list_node.design_user = $AddAssemblyObj/VBoxContainer/HBoxContainer3/LineEdit.text
	list_node.design_time = $AddAssemblyObj/VBoxContainer/HBoxContainer4/LineEdit.text
	list_node.tech_req = $AddAssemblyObj/VBoxContainer/HBoxContainer5/LineEdit.text
	list_node.shape = $AddAssemblyObj/VBoxContainer/HBoxContainer8/LineEdit.text
	list_node.pos_matrix = $AddAssemblyObj/VBoxContainer/HBoxContainer10/LineEdit.text
	list_node.benchmark = $AddAssemblyObj/VBoxContainer/HBoxContainer11/LineEdit.text
	update_assembly_object_tree()


# 在同级中向上移动一次
func move_assembly_object_up():
	print("up")
	# 获得当前节点
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		close_assObjPopWin()
		return
	# 寻找交换目标
	var changeVarAssObj = null
	for varAssObj in assemblyObjectList:
		if varAssObj.parent_id == list_node.parent_id and varAssObj.tree_index < list_node.tree_index:
			if changeVarAssObj == null:
				changeVarAssObj = varAssObj
				continue
			if changeVarAssObj.tree_index < varAssObj.tree_index:
				changeVarAssObj = varAssObj
	# 交换位置
	if changeVarAssObj != null:
		var temp_tree_index = changeVarAssObj.tree_index
		changeVarAssObj.tree_index = list_node.tree_index
		list_node.tree_index = temp_tree_index
	close_assObjPopWin()
	update_assembly_object_tree()


# 在同级中向下移动一次
func move_assembly_object_down():
	print("down")
	# 获得当前节点
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		close_assObjPopWin()
		return
	# 寻找交换目标
	var changeVarAssObj = null
	for varAssObj in assemblyObjectList:
		if varAssObj.parent_id == list_node.parent_id and varAssObj.tree_index > list_node.tree_index:
			if changeVarAssObj == null:
				changeVarAssObj = varAssObj
				continue
			if changeVarAssObj.tree_index > varAssObj.tree_index:
				changeVarAssObj = varAssObj
	# 交换位置
	if changeVarAssObj != null:
		var temp_tree_index = changeVarAssObj.tree_index
		changeVarAssObj.tree_index= list_node.tree_index
		list_node.tree_index = temp_tree_index
	close_assObjPopWin()
	update_assembly_object_tree()


# 将节点设置为上一个节点的子节点
func move_assembly_deep():
	print("deep")
	# 获得当前节点
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		close_assObjPopWin()
		return
	# 寻找作为新父节点的节点
	var changeVarAssObj = null
	for varAssObj in assemblyObjectList:
		if varAssObj.parent_id == list_node.parent_id and varAssObj.tree_index < list_node.tree_index:
			if changeVarAssObj == null:
				changeVarAssObj = varAssObj
				continue
			if changeVarAssObj.tree_index < varAssObj.tree_index:
				changeVarAssObj = varAssObj
	# 修改父节点编号和tree_index和tree_depth
	if changeVarAssObj != null:
		list_node.parent_id = changeVarAssObj.id
		for varAssObj in assemblyObjectList:
			if varAssObj.parent_id == 0:
				varAssObj.tree_depth = 0
			else:
				for vvarAssObj in assemblyObjectList:
					if vvarAssObj.id == varAssObj.parent_id:
						varAssObj.tree_depth = vvarAssObj.tree_depth + 1
						break
		for varAssObj in assemblyObjectList:
			if varAssObj.parent_id == list_node.parent_id and list_node.tree_index <= varAssObj.tree_index:
				list_node.tree_index = varAssObj.tree_index + 1
	# 关闭界面并更新树
	close_assObjPopWin()
	update_assembly_object_tree()


# 将节点从当前节点中脱离
func move_assembly_shallow():
	print("shallow")
	# 获得当前节点
	var select_tree_node = get_selected()
	var list_node = select_tree_node.get_metadata(0)
	if list_node == null:
		close_assObjPopWin()
		return
	# 如果已经是根节点的子节点，则不修改
	var parent_id = list_node.parent_id
	if parent_id == 0:
		close_assObjPopWin()
		return
	# 获得父节点
	var parent_node
	for varAssObj in assemblyObjectList:
		if varAssObj.id == parent_id:
			parent_node = varAssObj
	# 修改父节点编号和tree_index, tree_depth在update中更新
	list_node.parent_id = parent_node.parent_id
	list_node.tree_index = 0
	for varAssObj in assemblyObjectList:
		if varAssObj.parent_id == list_node.parent_id and list_node.tree_index <= varAssObj.tree_index:
			list_node.tree_index = varAssObj.tree_index + 1
	# 关闭界面并更新树
	close_assObjPopWin()
	update_assembly_object_tree()


#编辑树节点接口
func edit_assembly_product_object():
	var product = $"../../../../../../../..".product
	$AddAssemblyObj2.visible = true
	$AddAssemblyObj2.title = "查看产品信息"
	$AddAssemblyObj2/VBoxContainer/HBoxContainer/LineEdit.text = product.name
	$AddAssemblyObj2/VBoxContainer/HBoxContainer2/LineEdit.text = product.desc
	$AddAssemblyObj2/VBoxContainer/HBoxContainer3/LineEdit.text = product.owner
	$AddAssemblyObj2/VBoxContainer/HBoxContainer4/LineEdit.text = product.date
	$AddAssemblyObj2/VBoxContainer/HBoxContainer5/LineEdit.text = product.modifydate
	$AddAssemblyObj2/VBoxContainer/HBoxContainer6/LineEdit.text = product.modifyperson
	$AddAssemblyObj2/VBoxContainer/HBoxContainer7/LineEdit.text = product.id
	
	$AddAssemblyObj2/VBoxContainer/HBoxContainer/LineEdit.editable = true
	$AddAssemblyObj2/VBoxContainer/HBoxContainer2/LineEdit.editable = true
	$AddAssemblyObj2/VBoxContainer/HBoxContainer3/LineEdit.editable = true
	$AddAssemblyObj2/VBoxContainer/HBoxContainer4/LineEdit.editable = true
	$AddAssemblyObj2/VBoxContainer/HBoxContainer5/LineEdit.editable = true
	$AddAssemblyObj2/VBoxContainer/HBoxContainer6/LineEdit.editable = true
	$AddAssemblyObj2/VBoxContainer/HBoxContainer7/LineEdit.editable = true
	close_assObjPopWin()


#查看树节点信息接口
func check_assembly_product_object():
	var product = $"../../../../../../../..".product
	$AddAssemblyObj2.visible = true
	$AddAssemblyObj2.title = "编辑产品信息"
	$AddAssemblyObj2/VBoxContainer/HBoxContainer/LineEdit.text = product.name
	$AddAssemblyObj2/VBoxContainer/HBoxContainer2/LineEdit.text = product.desc
	$AddAssemblyObj2/VBoxContainer/HBoxContainer3/LineEdit.text = product.owner
	$AddAssemblyObj2/VBoxContainer/HBoxContainer4/LineEdit.text = product.date
	$AddAssemblyObj2/VBoxContainer/HBoxContainer5/LineEdit.text = product.modifydate
	$AddAssemblyObj2/VBoxContainer/HBoxContainer6/LineEdit.text = product.modifyperson
	$AddAssemblyObj2/VBoxContainer/HBoxContainer7/LineEdit.text = product.id
	
	$AddAssemblyObj2/VBoxContainer/HBoxContainer/LineEdit.editable = false
	$AddAssemblyObj2/VBoxContainer/HBoxContainer2/LineEdit.editable = false
	$AddAssemblyObj2/VBoxContainer/HBoxContainer3/LineEdit.editable = false
	$AddAssemblyObj2/VBoxContainer/HBoxContainer4/LineEdit.editable = false
	$AddAssemblyObj2/VBoxContainer/HBoxContainer5/LineEdit.editable = false
	$AddAssemblyObj2/VBoxContainer/HBoxContainer6/LineEdit.editable = false
	$AddAssemblyObj2/VBoxContainer/HBoxContainer7/LineEdit.editable = false
	close_assObjPopWin()


#编辑产品信息确认接口
func confirm_edit_assembly_product():
	var product = $"../../../../../../../..".product
	product.name = $AddAssemblyObj2/VBoxContainer/HBoxContainer/LineEdit.text
	product.desc = $AddAssemblyObj2/VBoxContainer/HBoxContainer2/LineEdit.text
	product.owner = $AddAssemblyObj2/VBoxContainer/HBoxContainer3/LineEdit.text
	product.date = $AddAssemblyObj2/VBoxContainer/HBoxContainer4/LineEdit.text
	product.modifydate = $AddAssemblyObj2/VBoxContainer/HBoxContainer5/LineEdit.text
	product.modifyperson = $AddAssemblyObj2/VBoxContainer/HBoxContainer6/LineEdit.text
	product.id = $AddAssemblyObj2/VBoxContainer/HBoxContainer7/LineEdit.text
	update_assembly_object_tree()
