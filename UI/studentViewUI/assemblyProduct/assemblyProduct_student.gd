extends Node

enum AssemblyObjType {zongZhuang, zongCheng, buJian}

@onready var model_path = get_node("/root/Global").project_path +"\\"					# 输入模型的路径
@onready var model_root_folder_path = model_path + "model\\"	# 模型存储的位置


@onready var assmblyObject2Node3D = $"../../ColorRect/VSplitContainer/HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".assmblyObject2Node3D

var assemblyObjectList = []
var assemblyModel = []
var WorkStep_to_therblig = {}

func get_assembly_object_children(id):

	var childrenList = []
	for varItem in assemblyObjectList:
		if varItem.parent_id == id:
			childrenList.append(varItem)
	return childrenList


func get_assembly_object_end_children(id):
	var returnList = []
	var curItem
	for varItem in assemblyObjectList:
		if varItem.id == id:
			curItem = varItem
		if varItem.parent_id == id:
			returnList.append_array(get_assembly_object_end_children(varItem.id))
	if returnList.size() == 0:
		returnList.append(curItem)
	return returnList



# 递归生成装配对象和装配模型树，并添加到tbScene中
func generate_Node3D_Tree(item, rootNode:Node3D):
	# 如果是根节点
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
		var addModel = assemblyModel[item.modelLink]
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
				meshInstanceModel.set_surface_override_material(surface_id, "res://Model/Material/normal_material.tres")
		rootNode.add_child(importModel)
		assmblyObject2Node3D[int(item.id)] = importModel
		importModel.visible = true
