extends Node3D

@export var checkSize = 0.15

signal objAssemblyEnd
signal objRelease

@onready var targetObj = $"../PickableObject"

var targetPos = Vector3(0.0, 0.0, 0.0)
var enable = false
var pickUp = false
var assemblyStatus = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !enable:
		return
	# 计算体中央位置
	var modelAABB = scene_get_aabb(targetObj)
	if modelAABB == null:
		enable = false
		print("装配位置检测：位置无效")
		assemblyStatus = false
		objAssemblyEnd.emit()
		return
	var middlePosition = modelAABB.position + modelAABB.size/2
	# print("targetPos: " ,  targetPos , "nowPos: " , middlePosition)
	# 比较位置关系
	if middlePosition.distance_to(targetPos) < checkSize:
		if !pickUp:
			print("装配位置检测：装配成功")
			enable = false
			assemblyStatus = true
			objAssemblyEnd.emit()
			
	

func startCheckObjInPlace(targetPosition):
	targetPos = targetPosition
	enable = true

func stopCheckObjInPlace():
	enable = false


func _on_pickable_object_picked_up(pickable):
	if pickable == $"../PickableObject":
		print("装配位置检测：物体被拿起")
		pickUp = true


func _on_pickable_object_dropped(pickable):
	if pickable == $"../PickableObject":
		print("装配位置检测：物体被释放")
		pickUp = false
		objRelease.emit()


func scene_get_aabb(node):
	if node is MeshInstance3D:
		var local_aabb = node.get_aabb()
		var local_p0 = local_aabb.position
		var local_p1 = local_aabb.position + local_aabb.size
		var global_p0 = node.to_global(local_p0)
		var global_p1 = node.to_global(local_p1)
		var new_aabb = AABB(global_p0, Vector3(0, 0, 0))
		new_aabb = new_aabb.expand(global_p1)
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
		return aabb
	return null
