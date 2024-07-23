extends CheckButton

var normal_material = load("res://Model/Material/normal_material.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func use_normal_material_change(button_pressed):
	if button_pressed:
		global_use_normal_material()
	else:
		global_use_mesh_material()

func global_use_normal_material():
	use_normal_material($"../../HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/模型显示/SubViewport/Node3D".get_scene_node())
	use_normal_material($"../../HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".get_scene_node())
	$"../../HSplitContainer2/VSplitContainer/VBoxContainer2/BoxContainer/assemblyProduct".use_normal_material = true

func global_use_mesh_material():
	use_mesh_material($"../../HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/模型显示/SubViewport/Node3D".get_scene_node())
	use_mesh_material($"../../HSplitContainer2/HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene".get_scene_node())
	$"../../HSplitContainer2/VSplitContainer/VBoxContainer2/BoxContainer/assemblyProduct".use_normal_material = false

	
func use_normal_material(node):
	if node is MeshInstance3D:
		node.material_override = normal_material
		return
	for var_child in node.get_children():
		use_normal_material(var_child)


func use_mesh_material(node):
	if node is MeshInstance3D:
		node.material_override = null
		return
	for var_child in node.get_children():
		use_mesh_material(var_child)

