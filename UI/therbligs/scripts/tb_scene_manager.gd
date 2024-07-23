extends Node3D

# 装配动素的类型：相机动素、工步动素、工具动素、模型动素
enum TherbligType 
{
	camera, 
	workstep, 
	tool,
	model
}

# 单个动素装配完成的信号
signal assembly_therblig_down
# XR装配


var xr_interface: XRInterface

# 所有的3d装配对象资源都在assemblyModelScene中
# 需要将那里的3d装配对象资源加到该场景中
# 当添加模型动素，绑定装配对象后，会将装配对象在该场景中实例化为meshinstance

@onready var Camera = $Camera3D
@onready var AssemblyObjcetModel = $AssemblyModel

# 利用装配对象的id去索引对应的node3d
var assmblyObject2Node3D = {}


@onready var assemblyProductClass = $"../../../../../../VSplitContainer/VBoxContainer2/BoxContainer/assemblyProduct"

# 按照顺序的模型动素列表
var assembly_model_therblig_list = []

# 装配参数：空间半径，超过该范围的物体会被强制拉回
var assemblySpaceSize = 3

# 装配的状态
var assembly_enable = false
# 装配物品的初始放置位置
var assembly_obj_start_pos = Vector3(0.5, 0.8, -0.6)
# 装配的状态 装配中/未在装配中
var assemblying = false
# 装配到的物体的编号
var assemblyIndex = 0
# 装配高亮着色器
var outline_material


func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("VR初始化成功")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		print("VR初始化失败，请检查连接与设置")
	
	if assemblyProductClass == null:
		print("学生界面，使用Data/Model中的数据")
		assemblyProductClass = $"../../../../../../../../../Data/Model"


func _process(delta):
	# 每帧进行动素装配的检测
	var WorkStepList
	var WorkStep_to_therblig
	WorkStepList = $"../../../../../../VSplitContainer/VBoxContainer2/TabContainer/工艺管理/Tree".gongbu_list
	WorkStep_to_therblig = $"../../VSplitContainer/TabContainer/动素管理".WorkStep_to_therblig
	if assembly_enable and WorkStepList and WorkStep_to_therblig:
		VR_assembly(WorkStepList, WorkStep_to_therblig)


# #################################################
# ----------------工步动素-----------------------
# #################################################

# 用于存储每个引导的meshinstance对应的索引。 所有的引导meshinstanc存储在场景的WorkStepSign中

# 根据动素的signtype，创建meshinstance，加到WorkStepSig中
func create_sign_model(tb):
	var mi = MeshInstance3D.new()
	var source_mi = $WorkStepSignResource.get_children()[tb.signtype]
	mi.mesh = source_mi.mesh
	mi.set_surface_override_material(0, source_mi.get_surface_override_material(0))
	$WorkStepSign.add_child(mi)
	tb.model = mi
	print("成功创建一个sign")


# #################################################
# ----------------模型动素-----------------------
# #################################################

#清空当前装配模型，并重新显示
func set_AssemblyModel_scene():
	assembly_enable = false
	# 清空原有内容
	assmblyObject2Node3D.clear()
	for n in AssemblyObjcetModel.get_children():
		AssemblyObjcetModel.remove_child(n)
		n.free()
	# 新建模型和各种关系
	var rootNode = Node3D.new()
	assemblyProductClass.generate_Node3D_Tree(null, rootNode)
	AssemblyObjcetModel.add_child(rootNode)
	rootNode.global_position = Vector3(0, 0, 0)
	var aabb = scene_get_aabb(rootNode)
	#print("总装配对象AABB")
	#print(aabb)
	var maxSize
	if aabb != null:  
		maxSize = max(aabb.size.x, aabb.size.y, aabb.size.z)  
	else:  
		print("无法获取边界框")
	#var maxSize = max(aabb.size.x, aabb.size.y, aabb.size.z)
	var scale = 1 / maxSize
	rootNode.scale = Vector3(scale, scale, scale)
	rootNode.position = (-aabb.position - aabb.size / 2) * scale
	set_mesh_visible(rootNode,false)
	$PickableObject/Model.scale = rootNode.scale
	# 给ItemList生成内容
	var WorkStepList
	var WorkStep_to_therblig
	if $"../../../../../../../../../Data/Model":
		WorkStepList = $"../../../../../../VBoxContainer/TabContainer/工艺管理/Tree".gongbu_list
		WorkStep_to_therblig = $"../../../../../../../../../Data/Model".WorkStep_to_therblig
	else:
		WorkStepList = $"../../../../../../VSplitContainer/VBoxContainer2/TabContainer/工艺管理/Tree".gongbu_list
		WorkStep_to_therblig = $"../../VSplitContainer/TabContainer/动素管理".WorkStep_to_therblig
	set_AssemblyModel_itemList(WorkStepList, WorkStep_to_therblig)
	# 生成高亮着色器
	outline_material = create_outline_material()
	#设置所有物体可见
	set_mesh_visible(rootNode,true)
	

func create_Model_model(tb):
	
	var modelNode = assmblyObject2Node3D[tb.modelID]
	set_mesh_visible(modelNode, true)
	tb.model = modelNode

	
# #################################################
# ----------------相机动素-----------------------
# #################################################

	
# #################################################
# ----------------工具动素-----------------------
# #################################################
func create_tool_model(tb):
	var temp_tool = $"../../VSplitContainer/TabContainer/动素管理".find_tool(tb.toolID)
	var path = temp_tool.path
	var model = load(path)
	var mi = MeshInstance3D.new()
	mi.mesh = model
	var aabb = mi.get_aabb()
	#print(aabb)
	var maxSize = max(aabb.size.x, aabb.size.y, aabb.size.z)
	var scale = 15 / maxSize
	mi.scale = Vector3(scale, scale, scale)
	mi.position = Vector3(0, 0, 0)
	$AssemblyTool.add_child(mi)
	tb.model = mi
	



		
# #################################################
# ----------------通用----------------------
# #################################################

func set_mesh_visible(obj, visibility:bool):
	if obj is Node3D and !(obj is MeshInstance3D):
		var renderers:Array = obj.find_children("","MeshInstance3D",true,false)
		for i in range(len(renderers)):
			renderers[i].visible = visibility
	else:
		obj.visible = visibility


# 根据优先级播放所有工步的动画
func play_all_anima(WorkStepList, WorkStep_to_therblig):
	clear_model()
	print("播放所有动画的工步size：", WorkStepList.size())
	for i in range(WorkStepList.size()):
		var cur_workstep:int = WorkStepList[i].id
		if WorkStep_to_therblig.has(cur_workstep) == false:
			WorkStep_to_therblig[cur_workstep] = []
		var cur_tb_list = WorkStep_to_therblig[cur_workstep]
		var backup = cur_tb_list.duplicate(true)
		backup.sort_custom(func(a, b):return a.priority < b.priority)
		var k = 0
		while(k < backup.size()):
			var cur_tb = backup[k]
			var max_tween_time:float = cur_tb.time
			print("当前运行动画： ",cur_tb.name)
			var temp_twen_list = []
			for j in range(k, backup.size()):
				var ne_tb = backup[j]
				if ne_tb.priority == cur_tb.priority:
					max_tween_time = max(max_tween_time, ne_tb.time)
					var ne_tween = create_tb_tween(ne_tb)
					temp_twen_list.append(ne_tween)
					ne_tween.play()
					k = k + 1
			print("最大动画时间: ", max_tween_time)
			await get_tree().create_timer(max_tween_time).timeout




# 为模型动素添加动画
func create_tb_tween(tb)->Tween:

	match tb.type:
		TherbligType.camera:
			var temp_tween = Camera.create_tween()
			var start_pos = tb.startpos
			var end_pos = tb.endpos
			Camera.position = start_pos
			temp_tween.tween_property(Camera, "position", end_pos, tb.time).from(start_pos)
			temp_tween.pause()
			return temp_tween
			
		TherbligType.workstep:
			var temp_3Dmodel = get_3Dmodel(tb)
			if temp_3Dmodel != null:
				var temp_tween = temp_3Dmodel.create_tween()
				var start_pos = tb.startpos
				var end_pos = tb.endpos
				temp_3Dmodel.position = start_pos
				set_mesh_visible(temp_3Dmodel, true)
				temp_tween.tween_property(temp_3Dmodel, "position", end_pos, tb.time).from(start_pos)
				temp_tween.pause()
				temp_tween.connect("finished", set_mesh_visible.bind(temp_3Dmodel, false))
				return temp_tween
				
		TherbligType.model:
			var temp_3Dmodel = get_3Dmodel(tb)
			if temp_3Dmodel != null:
				var temp_tween = temp_3Dmodel.create_tween()
				var start_pos = tb.startpos
				var end_pos = tb.endpos
				temp_3Dmodel.position = start_pos
				set_mesh_visible(temp_3Dmodel, true)
				temp_tween.tween_property(temp_3Dmodel, "position", end_pos, tb.time).from(start_pos)
				temp_tween.pause()
				return temp_tween
				
		TherbligType.tool:
			var temp_3Dmodel = get_3Dmodel(tb)
			if temp_3Dmodel != null:
				var loop_num = floor(tb.time / 0.4)
				var temp_tween = temp_3Dmodel.create_tween()
				set_mesh_visible(temp_3Dmodel, true)
				for i in range(loop_num):
					temp_tween.tween_property(temp_3Dmodel, "visible", false, 0.2)
					temp_tween.tween_property(temp_3Dmodel, "visible", true, 0.2)
				temp_tween.pause()
				return temp_tween
	return 


	
# 清除所有模型，关闭动素管理界面时调用
func clear_model():
	for n in $AssemblyModel.get_children():
		set_mesh_visible(n, false)
	for n in $WorkStepSign.get_children():
		$WorkStepSign.remove_child(n)
		n.free()
	for n in $AssemblyTool.get_children():
		$AssemblyTool.remove_child(n)
		n.free()


# 播放模型动素动画，右键模型动素，选择“播放动画”时调用
func play_tb_anima(tb):
	tb.anima = create_tb_tween(tb)
	if tb.type == TherbligType.model or tb.type == TherbligType.workstep or tb.type == TherbligType.tool:
		var temp_3Dmodel = get_3Dmodel(tb)
		set_mesh_visible(temp_3Dmodel, true)
	tb.anima.play()


# 根据动素获取模型
func get_3Dmodel(tb):
	var temp_3Dmodel
	if tb.type == TherbligType.model:
		if (tb is Dictionary and !tb.has("model")) or tb.model == null:
			create_Model_model(tb)
		temp_3Dmodel = tb.model
	elif tb.type == TherbligType.workstep:
		if (tb is Dictionary and !tb.has("model")) or tb.model == null:
			create_sign_model(tb)
		temp_3Dmodel = tb.model
	elif tb.type == TherbligType.tool:
		if tb.model == null:
			create_tool_model(tb)
		temp_3Dmodel = tb.model
	return temp_3Dmodel
	
	
# 当点击动素itemlist时调用，如果选择的为模型动素，则显示该模型在动素显示窗口
func change_model(tb):
	if tb.type == TherbligType.camera:
		var end_pos = tb.endpos
		Camera.position = end_pos
	else:
		clear_model()
		if tb.type == TherbligType.workstep or tb.type == TherbligType.model:
			var temp_3Dmodel = get_3Dmodel(tb)
			set_mesh_visible(temp_3Dmodel, true)
			# 将模型移到终止位置
			temp_3Dmodel.position = tb.endpos
		elif tb.type == TherbligType.tool:
			var temp_3Dmodel = get_3Dmodel(tb)
			set_mesh_visible(temp_3Dmodel, true)


func change_scene(scene):
	for n in $Scene.get_children():
		$Scene.remove_child(n)
		n.queue_free()
	var scene_intance = load(scene.url).instantiate()
	$Scene.add_child(scene_intance)


# 根据优先级播放单个工步的动画
func play_workstep_anima(list_node, WorkStepList, WorkStep_to_therblig):
	clear_model()
	anima_jump_to(list_node, WorkStepList, WorkStep_to_therblig)
	var cur_workstep:int = list_node.id
	if WorkStep_to_therblig.has(cur_workstep) == false:
		WorkStep_to_therblig[cur_workstep] = []
	var cur_tb_list = WorkStep_to_therblig[cur_workstep]
	var backup = cur_tb_list.duplicate(true)
	backup.sort_custom(func(a, b):return a.priority < b.priority)
	var k = 0
	while(k < backup.size()):
		var cur_tb = backup[k]
		var max_tween_time:float = cur_tb.time
		print("当前运行动画： ",cur_tb.name)
		var temp_twen_list = []
		for j in range(k, backup.size()):
			var ne_tb = backup[j]
			if ne_tb.priority == cur_tb.priority:
				max_tween_time = max(max_tween_time, ne_tb.time)
				var ne_tween = create_tb_tween(ne_tb)
				temp_twen_list.append(ne_tween)
				ne_tween.play()
				k = k + 1
		print("最大动画时间: ", max_tween_time)
		await get_tree().create_timer(max_tween_time).timeout


func anima_jump_to(list_node, WorkStepList, WorkStep_to_therblig):
	for i in range(WorkStepList.size()):
		var cur_workstep:int = WorkStepList[i].id
		if cur_workstep == list_node.id:
			return
		if WorkStep_to_therblig.has(cur_workstep) == false:
			WorkStep_to_therblig[cur_workstep] = []
		var cur_tb_list = WorkStep_to_therblig[cur_workstep]
		var backup = cur_tb_list.duplicate(true)
		var k = 0
		while(k < backup.size()):
			var cur_tb = backup[k]
			if cur_tb.type == TherbligType.model:
				var end_pos = cur_tb.endpos
				var temp_3Dmodel = get_3Dmodel(cur_tb)
				temp_3Dmodel.position = end_pos
				set_mesh_visible(temp_3Dmodel, true)
			k = k + 1


func anima_jump_to_therblig(therblig, WorkStepList, WorkStep_to_therblig, has_self):
	# 将所有模型设置为可见
	for n in $AssemblyModel.get_children():
		set_mesh_visible(n, true)
	# 目标模型前的设置为可见，目标模型后的设置为不可见
	var set_to_visible = true
	for i in range(WorkStepList.size()):
		var cur_workstep:int = WorkStepList[i].id
		if WorkStep_to_therblig.has(cur_workstep) == false:
			WorkStep_to_therblig[cur_workstep] = []
		var cur_tb_list = WorkStep_to_therblig[cur_workstep]
		var backup = cur_tb_list.duplicate(true)
		var k = 0
		while(k < backup.size()):
			var cur_tb = backup[k]
			if !has_self and cur_tb == therblig:
				print("找到可见设置部分的目标模型")
				set_to_visible = false
			if cur_tb.type == TherbligType.model:
				var end_pos = cur_tb.endpos
				var temp_3Dmodel = get_3Dmodel(cur_tb)
				temp_3Dmodel.position = end_pos
				if set_to_visible:
					set_mesh_visible(temp_3Dmodel, true)
				else:
					set_mesh_visible(temp_3Dmodel, false)
			if has_self and cur_tb == therblig:
				print("找到可见设置部分的目标模型")
				set_to_visible = false
			k = k + 1



#进行整个流程的装配
func VR_assembly(WorkStepList, WorkStep_to_therblig):
	# 如果装配物体超出界限，则重置位置
	if $PickableObject.position.x < -assemblySpaceSize or \
		$PickableObject.position.x > assemblySpaceSize or \
		$PickableObject.position.y < 0 or \
		$PickableObject.position.y > assemblySpaceSize or \
		$PickableObject.position.z < -assemblySpaceSize or \
		$PickableObject.position.z > assemblySpaceSize:
		reset_pickableObject()
#	clear_model()
#	print("进行整个流程的装配：", WorkStepList.size())
#	for i in range(WorkStepList.size()):
#		var cur_workstep:int = WorkStepList[i].id
#		if WorkStep_to_therblig.has(cur_workstep) == false:
#			WorkStep_to_therblig[cur_workstep] = []
#		var cur_tb_list = WorkStep_to_therblig[cur_workstep]
#		var backup = cur_tb_list.duplicate(true)
#		backup.sort_custom(func(a, b):return a.priority < b.priority)
#		var k = 0
#		while(k < backup.size()):
#			var cur_tb = backup[k]
#			print("当前装配进程： ",cur_tb.name)
#			VR_therblig_assembly(cur_tb)
#			print("装配进程", cur_tb.name, "已完成")
##			await $ObjectInPlaceControl.objInPlace
#			k = k + 1
	if assemblying:
		return
	assemblying = true
	# 获取界面部件
	var percentage_lable = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/HBoxContainer/processbar/percentage
	var name_lable = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/HBoxContainer/processbar/name
	var itemList = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/ItemList
	var hslider = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/HBoxContainer/processbar/HSlider
	var volumePercentage:String
	var n = assembly_model_therblig_list.size()
	# 装配完成或超过界限
	if assemblyIndex >= n:
		itemList.deselect_all()
		percentage_lable.text = "100%"
		hslider.value = 100
		name_lable.text = "暂无部件"
		assemblying = false
		return
	# 等待手柄将部件放下
	if $ObjectInPlaceControl.pickUp == true:
		await $ObjectInPlaceControl.objRelease
	# 调整界面中的内容
	itemList.select(assemblyIndex)
	hslider.value = assemblyIndex  * 100 / n
	volumePercentage = str(hslider.value) + "%"
	percentage_lable.text = volumePercentage
	name_lable.text = itemList.get_item_text(assemblyIndex)
	# 进行装配
	print("第", assemblyIndex, "个物体开始装配")
	VR_therblig_assembly(assembly_model_therblig_list[assemblyIndex])
	# 装配结束进行处理
	await assembly_therblig_down
	if $ObjectInPlaceControl.assemblyStatus:
		assemblyIndex  = assemblyIndex + 1
		print("装配成功，开始装配第", assemblyIndex, "个物体")
	assemblying = false


# 跳转到index进行装配
func VR_assembly_jump_to(index): 
	assembly_enable = true
	$ObjectInPlaceControl.stopCheckObjInPlace()
	$ObjectInPlaceControl.assemblyStatus = false
	$ObjectInPlaceControl.objAssemblyEnd.emit()
	assemblyIndex = index


#进行单个工步的装配(未使用，可能有bug)
#func VR_workstep_assembly(list_node, WorkStepList, WorkStep_to_therblig):
#	clear_model()
#	anima_jump_to(list_node, WorkStepList, WorkStep_to_therblig)
#	var cur_workstep:int = list_node.id
#	if WorkStep_to_therblig.has(cur_workstep) == false:
#		WorkStep_to_therblig[cur_workstep] = []
#	var cur_tb_list = WorkStep_to_therblig[cur_workstep]
#	var backup = cur_tb_list.duplicate(true)
#	backup.sort_custom(func(a, b):return a.priority < b.priority)
#	var k = 0
#	while(k < backup.size()):
#		var cur_tb = backup[k]
#		print("当前装配进程： ",cur_tb.name)
#		VR_therblig_assembly(cur_tb)
#		print("装配进程", cur_tb.name, "已完成")
##		await $ObjectInPlaceControl.objInPlace
#		k = k + 1
#	pass
	


# 进行单个动素的装配
func VR_therblig_assembly(therblig):
	# 非模型动素不处理
	var modelInScene = $PickableObject/Model
	if therblig.type != TherbligType.model:
		assembly_therblig_down.emit()
		return
	var WorkStepList
	var WorkStep_to_therblig
	if $"../../../../../../../../../Data/Model":
		WorkStepList = $"../../../../../../VBoxContainer/TabContainer/工艺管理/Tree".gongbu_list
		WorkStep_to_therblig = $"../../../../../../../../../Data/Model".WorkStep_to_therblig
	else:
		WorkStepList = $"../../../../../../VSplitContainer/VBoxContainer2/TabContainer/工艺管理/Tree".gongbu_list
		WorkStep_to_therblig = $"../../VSplitContainer/TabContainer/动素管理".WorkStep_to_therblig
	var small_obj_show = $PickableObject/SmallObjShow
	# 告诉对面要更新，并且拿到返回的确认 TODO?
	$ObjectInPlaceControl.stopCheckObjInPlace()
	# 设置装配模型
	clear_model()
	anima_jump_to_therblig(therblig, WorkStepList, WorkStep_to_therblig, true)
	# 清除可抓取物体的模型
	for varChild in modelInScene.get_children():
		modelInScene.remove_child(varChild)
		varChild.free()
	# 生成新的可抓取物体模型
	var targetModel = get_3Dmodel(therblig)
	if targetModel != null:
		print("在场景中替换可抓取物体的模型")
		var newModel = nodeCopy(targetModel)
		# 添加装配模型
		modelInScene.add_child(newModel)
		# 将位置放在装配对象的正中心
		reset_pickableObject()
		var source_AABB = scene_get_aabb(newModel)
		var target_AABB = scene_get_aabb(targetModel)
		var scale = target_AABB.size.x / source_AABB.size.x
		newModel.scale = Vector3(scale, scale, scale)
		newModel.global_position = Vector3(0, 0, 0)
		source_AABB = scene_get_aabb(newModel)
		#print(source_AABB)
		newModel.global_position = -(source_AABB.position + source_AABB.size/2) + assembly_obj_start_pos
		# 计算目标位置中心
		var temp_position = targetModel.position
		targetModel.position = therblig.endpos
		var modelAABB = scene_get_aabb(targetModel)
		var middlePosition = modelAABB.position + modelAABB.size/2
		targetModel.position = temp_position
		# 计算物体大小
		var modelMaxSize = max(source_AABB.size.x, source_AABB.size.y, source_AABB.size.z)
		# 进行装配控制，同时设置小物体提示和装配目标高亮
		print("开始装配")
		if (modelMaxSize < 0.1):
			small_obj_show.visible = true
		add_outline(targetModel)
		$ObjectInPlaceControl.startCheckObjInPlace(middlePosition)
		await $ObjectInPlaceControl.objAssemblyEnd
		small_obj_show.visible = false
		remove_outline(targetModel)
	# 清除可抓取物体的模型
	for varChild in modelInScene.get_children():
		modelInScene.remove_child(varChild)
		varChild.free()
	reset_pickableObject()
	assembly_therblig_down.emit()
	
	
# 重置可抓取物体的位置和速度
func reset_pickableObject():
	$PickableObject.position = assembly_obj_start_pos
	$PickableObject.rotation = Vector3(0, 0, 0)
	$PickableObject.linear_velocity = Vector3(0, 0, 0)
	$PickableObject.angular_velocity = Vector3(0, 0, 0)
	

# 为itemlist生成内容
func set_AssemblyModel_itemList(WorkStepList, WorkStep_to_therblig):
	# 将抓取物体设置为不可见
	$PickableObject.visible = false
	
	var itemList = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/ItemList
	var hslider = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/HBoxContainer/processbar/HSlider
	if itemList == null:
		return
	itemList.clear()
	
	# 创建Viewport
	var viewport_container = SubViewportContainer.new()
	var viewport = SubViewport.new()
	var vp_camera = Camera3D.new()
	var camera_env:Environment = Environment.new()
	camera_env.background_mode = Environment.BG_COLOR
	camera_env.background_color = Color(0.6, 0.6, 0.6, 0)
	vp_camera.environment = camera_env
	vp_camera.fov = 90
	self.add_child(viewport_container)
	viewport_container.add_child(viewport)
	viewport.add_child(vp_camera)
	viewport.size = Vector2(1151, 644)
	viewport.scaling_3d_scale = 1.0
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport_container.size = viewport.size
	viewport_container.position = Vector2(-1000,0)
	
	# 获得所有动素
	var tbList = []
	for i in range(WorkStepList.size()):
		var cur_workstep:int = WorkStepList[i].id
		if WorkStep_to_therblig.has(cur_workstep) == false:
			WorkStep_to_therblig[cur_workstep] = []
		var cur_tb_list = WorkStep_to_therblig[cur_workstep]
		var backup = cur_tb_list.duplicate(true)
		backup.sort_custom(func(a, b):return a.priority < b.priority)
		tbList.append_array(backup)
	assembly_model_therblig_list = tbList
	# 为动素生成图像
	for i in range(tbList.size()):
		# 如果动素不是模型动素，则跳过
		if tbList[i].type != TherbligType.model:
			continue
		# 每次要初始化相机位置
		vp_camera.global_transform = Transform3D()
		vp_camera.global_position = Vector3(0, 1, 0)
		# 获得物体
		var obj = get_3Dmodel(tbList[i])
		set_mesh_visible(obj, true)

		var start_pos = obj.position
		var start_rot = obj.rotation
		var start_scale = obj.scale
		# 对物体进行转，以便观察更全面
		obj.global_position = Vector3.ZERO
		obj.global_rotation = Vector3.ZERO

#		obj.global_rotation_degrees = Vector3(0,90,0)
#		obj.global_rotate(Vector3(0,1,0),deg_to_rad(-30))
#		obj.global_rotate(Vector3(1,0,0),deg_to_rad(-30))

		var bounds:AABB = scene_get_aabb(obj)
		bounds.position = obj.to_global(bounds.position)
		#print(bounds)
		# 为了观察到物体，计算相机位置参数
		var horizontalDistance:float = bounds.size.x / (tan(deg_to_rad(vp_camera.fov) * 0.5) * 500/700)
		var verticalDistance:float = bounds.size.y / (tan(deg_to_rad(vp_camera.fov) * 0.5))
		var distance:float = max(horizontalDistance, verticalDistance)
		#print(distance)
		var cameraDistanceMultiplier:float = 1.8
		distance = distance * cameraDistanceMultiplier

		vp_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
		vp_camera.size = distance * 0.5
		vp_camera.near = 0.0001
		vp_camera.far = distance * 100.0

		vp_camera.position = bounds.get_center() - vp_camera.global_transform.basis.z * distance
		vp_camera.look_at(bounds.get_center())

		var viewport_vp_texture = viewport.get_texture()
		await RenderingServer.frame_post_draw
		var viewport_image:Image = viewport_vp_texture.get_image()
		var viewport_im_texture = ImageTexture.new()
		viewport_im_texture.set_image(viewport_image)
		itemList.add_item(obj.name, viewport_im_texture)
		
		obj.position = start_pos
		obj.rotation = start_rot
		obj.scale = start_scale
			
		set_mesh_visible(obj, false)
		
	# 为itemList绑定信号
	itemList.connect("item_selected", VR_itemList_item_selected)
	hslider.connect("drag_ended", VR_slider_item_jump)
	# 设置文本内容
	var percentage_lable = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/HBoxContainer/processbar/percentage
	var name_lable = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/HBoxContainer/processbar/name
	percentage_lable.text = ""
	name_lable.text = "暂无部件"
	
	# 将抓取物体设置为可见
	$PickableObject.visible = true


# 用户点击第index个物体，执行跳转
func VR_itemList_item_selected(index):
	print("用户点击，跳转到第", index, "个物体")
	VR_assembly_jump_to(index)


# 在检测到鼠标结束拖动slider信号时，执行跳转
func VR_slider_item_jump(a:bool):
	var hslider = $VRboard/Viewport2Din3D/Viewport/Control/Panel/VBoxContainer/HBoxContainer/processbar/HSlider
	var ratio:float = hslider.value
	var assembly_size = assembly_model_therblig_list.size()
	var index:int = floor(assembly_size * ratio / 100.0)
	print("进度条拖动结束，跳转到第", index, "个物体")
	VR_assembly_jump_to(index)


# ---------------------------------------------------------------------
# ---------------------------高亮功能------------------------------------
# ---------------------------------------------------------------------


# 创建高亮material
func create_outline_material()->ShaderMaterial:
	var outline_shader_material = ShaderMaterial.new()
	var outline_shader = Shader.new()
	outline_shader.code = load_shader()
	outline_shader_material.shader = outline_shader
	return outline_shader_material
	
# 当播放到当前obj(node3d)时，让其所有meshinstance子节点高亮
func add_outline(obj:Node3D):
	print("添加高亮效果")
	var renderers:Array = obj.find_children("", "MeshInstance3D", true, false)
	for i in range(len(renderers)):
		var imesh:Mesh = renderers[i].mesh.duplicate(true)
		var imaterial = imesh.surface_get_material(0).duplicate(true)
		imaterial.set_next_pass(outline_material)
		imesh.surface_set_material(0,imaterial)
		renderers[i].mesh = imesh

# 移除高亮效果
func remove_outline(obj:Node3D):
	print("移除高亮效果")
	var renderers:Array = obj.find_children("","MeshInstance3D", true, false)
	for i in range(len(renderers)):
		var imaterial = renderers[i].mesh.surface_get_material(0)
		imaterial.next_pass = null
		
# 高亮shader代码
func load_shader()->String:	
	var code:String = "shader_type spatial;
	// render_mode blend_add, depth_draw_never, cull_front;
	render_mode blend_mix, unshaded, cull_front, depth_test_disabled;

	uniform bool enable = true;
	uniform float outline_thickness = 0.02;
	uniform vec4 color : source_color  = vec4(0.0, 0.9, 0.0, 0.3);


	void vertex() {
		if (enable) {
			VERTEX += normalize(VERTEX) * outline_thickness;
		}
	}

	void fragment() {
		if (enable) {
			ALBEDO = color.rgb;
			ALPHA = color.a;
		}
	}"
	return code


# ---------------------------------------------------------------------
# ---------------------------辅助功能------------------------------------
# ---------------------------------------------------------------------


# 递归复制节点node并返回newNode
func nodeCopy(node):
	var newNode = node.duplicate()
	for varChild in node.get_children():
		newNode.add_child(nodeCopy(varChild))
	return newNode
	

# 递归获得所有的MeshInstance3D
	

# 获得一个node在世界坐标系下的AABB包围盒
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


func get_scene_node():
	return $AssemblyModel
