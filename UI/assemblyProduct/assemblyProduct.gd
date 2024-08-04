extends Control

enum AssemblyObjType {zongZhuang, zongCheng, buJian}

#@onready var model_path = get_node("/root/Global").project_path +"\\"	
#注释掉的和数据库有关
@onready var model_path = "import\\"				# 输入模型的路径
@onready var model_root_folder_path = model_path + "model\\"	# 模型存储的位置

@onready var pathSelectPopWin = $ImportAssemblyProduct	# 路径选择弹窗
@onready var assmblyObject2Node3D = $"../../../../HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".assmblyObject2Node3D

var use_normal_material = false
var normal_material = load("res://Model/Material/normal_material.tres")

var assemblyObjectList = []						# 生成的装配对象列表
var assemblyModel = []


func _ready():
	# 保证模型文件夹的位置存在
	DirAccess.make_dir_absolute(model_root_folder_path)
	print(DirAccess.make_dir_absolute(model_root_folder_path))


# 模型导入的接口，供外部调用
func import_model():
	assemblyObjectList = []
	assemblyModel = []
	pathSelectPopWin.visible = true
	$ImportAssemblyProduct/VBoxContainer/HBoxContainer/LineEdit.text = ""


# 输入路径后导入模型
func confirm_model_select():
	# 获取路径
	var choose_path = model_path + $ImportAssemblyProduct/VBoxContainer/HBoxContainer/LineEdit.text
	print("confirm_model_select\n	 model_path:"+choose_path)
	# 根据输入的路径，利用GLTFState和GLTFDocument导入模型

	var gltfState = GLTFState.new()
	var gltf = GLTFDocument.new()	
	#接收一个 GLTF 文件的路径，并通过 state 参数将该文件路径上的数据导入到给定的 GLTFState 对象。
	if gltf.append_from_file(choose_path, gltfState) != OK:
		return	
	#通过 state 参数接收一个 GLTFState 对象，并返回一个 Godot 引擎的场景节点。
	var importModel = gltf.generate_scene(gltfState)
	#将imporModel当作assembley product的子节点
	add_child(importModel)
	# importModel为场景的根节点，为Node类型，可以通过递归get_childer获得子节点。
	# 子节点有Node3D类型和MeshInstance3D类型
	print("		begin generate_object_model")
	generate_object_model(0, 0, importModel);
	#
				

# 递归生成装配对象和装配模型
func generate_object_model(parent_id, parent_depth, targetNode):
	var newItem = {}
	newItem.id = assemblyObjectList.size() + 1
	newItem.parent_id = parent_id
	newItem.tree_index = 0
	for varItem in assemblyObjectList:
		if varItem.parent_id == parent_id and newItem.tree_index <= varItem.tree_index:
			newItem.tree_index = varItem.tree_index + 1
	newItem.tree_depth = parent_depth + 1
	newItem.name = targetNode.name
	newItem.code = "assObj-" + str(newItem.id)
	newItem.design_user = ""
	newItem.design_time = ""
	newItem.tech_req = ""
	newItem.type = AssemblyObjType.buJian
	newItem.is_reference = false
	newItem.shape = ""
	newItem.color = Color.BLACK
	newItem.pos_matrix = ""
	newItem.benchmark = ""
	# 属性：位姿
	newItem.position = targetNode.position
	newItem.rotation = targetNode.rotation
	newItem.scale = targetNode.scale
	# 将模型位置暂时置空
	newItem.modelLink = -1
	assemblyObjectList.push_back(newItem)
	
	#遍历当前结点的子节点
	for var_child in targetNode.get_children():
		generate_object_model(newItem.id, newItem.tree_depth, var_child)
#		targetNode.remove_child(var_child)

	# 从父节点上脱离
	var parent_node = targetNode.get_parent()
	if parent_node != null:
		parent_node.remove_child(targetNode)
		
	# 如果当前节点是meshInstance，则增加新模型
	if targetNode is MeshInstance3D:
		print("generate_object_model:\n		this is MeshInstance")
		var newModel = {}
		newModel.id = assemblyModel.size()
		newModel.name = targetNode.name
		newModel.path = str(newModel.id) + ".glb"
		var gltfState = GLTFState.new()
		var gltf = GLTFDocument.new()
		var newNode = Node.new()
		newNode.add_child(targetNode)
		print("		"+targetNode.name)

		#接收一个 Godot 引擎的场景节点，并通过 state 参数将其及其后代导出到给定的 GLTFState 对象。
		gltf.append_from_scene(newNode, gltfState)
		#state 参数接收一个 GLTFState 对象，并将一个 glTF 文件写入文件系统。
		#glTF 文件的扩展名决定了它是一个 .glb 二进制文件还是一个 .gltf 文本文件。
		gltf.write_to_filesystem(gltfState, model_root_folder_path + newModel.path)
		assemblyModel.append(newModel)
		assemblyObjectList[newItem.id-1].modelLink = newModel.id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_assembly_object_children(id):
	var assemblyObjectList_tmp  = $"../../TabContainer/产品管理/Tree".assemblyObjectList
	var childrenList = []
	for varItem in assemblyObjectList_tmp:
		if varItem.parent_id == id:
			childrenList.append(varItem)
	return childrenList


func get_assembly_object_end_children(id):
	var returnList = []
	var curItem
	var assemblyObjectList_tmp  = $"../../TabContainer/产品管理/Tree".assemblyObjectList
	for varItem in assemblyObjectList_tmp:
		if varItem.id == id:
			curItem = varItem
		if varItem.parent_id == id:
			returnList.append_array(get_assembly_object_end_children(varItem.id))
	if returnList.size() == 0:
		returnList.append(curItem)
	return returnList

# 递归生成装配对象和装配模型
func generate_object_Node3D(item, rootNode:Node3D):
	# 如果是根节点
	var assemblyModel_tmp = $"../../../VBoxContainer/VBoxContainer/TabContainer/装配对象3D模型/ItemList".model
	if item == null:
		var newNode:Node3D = Node3D.new()
		rootNode.add_child(newNode)
		var children_items = get_assembly_object_children(0)
		for child in children_items:
			generate_object_Node3D(child, newNode)
		return
	# 如果是父节点
	if item.modelLink == -1:
		var newNode:Node3D = Node3D.new()
		# 设置位姿属性
		newNode.position = item.position
		newNode.rotation = item.rotation
		newNode.scale = item.scale
		rootNode.add_child(newNode)
		var children_items = get_assembly_object_children(item.id)
		for child in children_items:
			generate_object_Node3D(child, newNode)
	else:
		# 如果当前节点不是父节点，说明当前节点meshinstance，则获取该节点的模型，将其加到node3d下
		var addModel = assemblyModel_tmp[item.modelLink]
		# 从model path生成meshinstance
		var gltfState = GLTFState.new()
		var gltf = GLTFDocument.new()
		if gltf.append_from_file(model_root_folder_path + addModel.path, gltfState) != OK:
			return
		var importModel = gltf.generate_scene(gltfState)
		# 如果物体上没有材质则附加材质
		var meshInstanceModel = importModel.get_child(0).get_child(0)
		for surface_id in meshInstanceModel.mesh.get_surface_count():
			if meshInstanceModel.mesh.surface_get_material(surface_id) == null:
				meshInstanceModel.set_surface_override_material(surface_id, normal_material)
			if use_normal_material:
				meshInstanceModel.material_override = normal_material
		rootNode.add_child(importModel)

#1
# 递归生成装配对象和装配模型树，并添加到tbScene中
func generate_Node3D_Tree(item, rootNode:Node3D):
	print("begin generate_node3D_tree")
	# 如果是根节点
	var assemblyModel_tmp = $"../../../VBoxContainer/VBoxContainer/TabContainer/装配对象3D模型/ItemList".model
	if item == null:
		var newNode:Node3D = Node3D.new()
		rootNode.add_child(newNode)
		var children_items = get_assembly_object_children(0)
		assmblyObject2Node3D[0] = newNode
		newNode.visible = true
		for child in children_items:
			generate_Node3D_Tree(child, newNode)
		return
	# 如果是父节点
	if item.modelLink == -1:
		var newNode:Node3D = Node3D.new()
		# 设置位姿属性
		newNode.position = item.position
		newNode.rotation = item.rotation
		newNode.scale = item.scale
		rootNode.add_child(newNode)
		var children_items = get_assembly_object_children(item.id)
		assmblyObject2Node3D[int(item.id)] = newNode
		newNode.visible = true
		for child in children_items:
			generate_Node3D_Tree(child, newNode)
	else:
		# 如果当前节点不是父节点，说明当前节点meshinstance，则获取该节点的模型，将其加到node3d下
		var addModel = assemblyModel_tmp[item.modelLink]
		# 从model path生成meshinstance
		var gltfState = GLTFState.new()
		var gltf = GLTFDocument.new()
		if gltf.append_from_file(model_root_folder_path + addModel.path, gltfState) != OK:
			return
		var importModel = gltf.generate_scene(gltfState)
		# 如果物体上没有材质则附加材质
		var meshInstanceModel = importModel.get_child(0).get_child(0)
		for surface_id in meshInstanceModel.mesh.get_surface_count():
			if meshInstanceModel.mesh.surface_get_material(surface_id) == null:
				meshInstanceModel.set_surface_override_material(surface_id, normal_material)
			if use_normal_material:
				meshInstanceModel.material_override = normal_material
		rootNode.add_child(importModel)
		assmblyObject2Node3D[int(item.id)] = importModel
		importModel.visible = true
		var t:StaticBody3D = StaticBody3D.new()
		var tt:CollisionShape3D = CollisionShape3D.new()
		tt.shape = BoxShape3D.new()
		t.add_child(tt)
		meshInstanceModel.add_child(t)
		tt.scale = Vector3(100,100,100)
		
		print("_______")
		print(meshInstanceModel.name)
		print(meshInstanceModel.get_class())
		#meshInstanceModel.visible = false

