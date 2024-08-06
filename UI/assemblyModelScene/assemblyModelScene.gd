extends VBoxContainer

var testmodelPath = "res://Model/AssemblyModel/扳手工具.obj"
#var model1 = preload("res://Model/AssemblyModel/扳手工具.obj")
#var model2 = preload("res://Model/AssemblyModel/zzt5.glb")
#var model3 = preload("res://Model/AssemblyModel/新扳手.obj")
@onready var scene = $SubViewport/Node3D
@onready var assemblyProductClass = $"../../../../VSplitContainer/VBoxContainer2/BoxContainer/assemblyProduct"
@onready var camera3D = $SubViewport/Node3D/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# 供res文件调试使用
func show_res_model(path):
	var model = load(path)
	var node3d
	# gltf
	if model is PackedScene:
		node3d = model.instantiate()
	# obj
	else:
		var meshInstance = MeshInstance3D.new()
		meshInstance.mesh = model
		node3d = Node3D.new()
		node3d.add_child(meshInstance)
	if node3d != null:
		scene.change_scene(node3d)


# 供model显示使用
func show_model(path):
	print("show_model")
	var gltf_state = GLTFState.new()
	var gltf_doc = GLTFDocument.new()
	gltf_doc.append_from_file(path, gltf_state)
	var model = gltf_doc.generate_scene(gltf_state)
	scene.change_scene(model)

# 供装配对象显示使用
func show_assembly_obj(item):
	var rootNode = Node3D.new()
	# 递归生成场景树
	assemblyProductClass.generate_object_Node3D(item, rootNode)
	# 将生成的场景树添加到tbScene
	scene.change_scene(rootNode)

func _input(event):
	if event is InputEventKey:
		match event.keycode:
			KEY_W:
				scene.Camera.position += Vector3(0,0,-0.3)
			
			KEY_S:
				scene.Camera.position += Vector3(0,0,0.3)
			
			KEY_A:
				scene.Camera.position += Vector3(-0.3,0,0)
				#camera3D._a = event.pressed
			KEY_D:
				scene.Camera.position += Vector3(0.3,0,0)
				
			KEY_Q:
				scene.Camera.position += Vector3(0,0.3,0)
				
			KEY_E:
				scene.Camera.position += Vector3(0,-0.3,0)
				
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

