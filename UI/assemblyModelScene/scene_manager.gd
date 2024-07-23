extends Node3D

var meshInstance
var modelNode
var normal_material = load("res://Model/Material/normal_material.tres")

func _ready():
	pass


func _process(delta):
	pass


func scene_get_aabb(node):
	if node is MeshInstance3D:
		var local_aabb = node.get_aabb()
		var local_p0 = local_aabb.position
		var local_p1 = local_aabb.position + local_aabb.size
		var global_p0 = node.to_global(local_p0)
		var global_p1 = node.to_global(local_p1)
		var new_aabb = AABB(global_p0, Vector3(0, 0, 0))
		new_aabb = new_aabb.expand(global_p1)
#		var new_aabb = AABB(global_p0, global_p1 - global_p0)
#		print(global_aabb)
#		var new_aabb = AABB(local_aabb.position + node.position * node.scale, local_aabb.size * node.scale)
		print(new_aabb)
		return new_aabb
	if node.get_child_count() != 0:
		var aabb
		for var_node in node.get_children():
			var var_node_aabb = scene_get_aabb(var_node)
			if var_node_aabb != null:
				if aabb == null:
					aabb = var_node_aabb
				else:
					aabb = aabb.merge(var_node_aabb)
#		aabb.position = aabb.position + node.position
		print(aabb)
		return aabb
	return null


func change_scene(node):
	# 清空显示的模型
	for n in $Node.get_children():
		$Node.remove_child(n)
		n.queue_free()
	$Node.add_child(node)
	print(node)
	var aabb = scene_get_aabb(node)
	print(aabb)
	var maxSize = max(aabb.size.x, aabb.size.y, aabb.size.z)
	var scale = 1.1 / maxSize
	node.scale = Vector3(scale, scale, scale)
	node.position = (-aabb.position - aabb.size / 2) * scale
#	node.position = Vector3((-aabb.position.x) * scale + aabb.size, (-aabb.position.y) * scale, (-aabb.position.z) * scale)


func get_scene_node():
	return $Node
	
#func use_normal_material():
#	_use_normal_material($Node)
#
#
#func use_mesh_material():
#	_use_mesh_material($Node)
#
#
#func _use_normal_material(node):
#	if node is MeshInstance3D:
#		node.material_override = normal_material
#		return
#	for var_child in node.get_children():
#		_use_normal_material(var_child)
#
#
#func _use_mesh_material(node):
#	if node is MeshInstance3D:
#		node.material_override = null
#		return
#	for var_child in node.get_children():
#		_use_mesh_material(var_child)
	
