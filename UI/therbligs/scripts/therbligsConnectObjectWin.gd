extends Control

@onready var tree = $SelectModel/Tree

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 更新节点树
func show_assembly_object_tree():
	var assObjNode = $"../../../../../../../../../VSplitContainer/VBoxContainer2/TabContainer/产品管理/Tree"
	$SelectModel/Tree.clear()
	#生成根节点
	tree.set_column_titles_visible(false)
	var root = tree.create_item()
	root.set_text(0,$"../../../../../../../../../../../..".product.name)
	tree.set_hide_root(true)
	#生成后续节点
	for varObj in assObjNode.assemblyObjectList:
		var parent_node = root
		if varObj.parent_id == 0:
			parent_node = root
		else:
			for vvarObj in assObjNode.assemblyObjectList:
				if vvarObj.id == varObj.parent_id:
					parent_node = vvarObj.node
					break
			if parent_node == root:
				print("Error: can not find the father node")
		#构建树节点	
		varObj.node = tree.create_item(parent_node)
		varObj.node.set_text(0, varObj.name)
		varObj.node.set_metadata(0, varObj)
	$SelectModel.visible = true


func get_selected_item():
	var select_tree_node = $SelectModel/Tree.get_selected()
	var list_node = select_tree_node.get_metadata(0)
	return list_node
