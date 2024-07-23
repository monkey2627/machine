extends VBoxContainer


var current_scene = {}
var assembly_scenes = []
var scene_item_ui = preload("res://UI/assemblyScenes/assembly_scene_item.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	initData()
	update_scene_ui()
	pass # Replace with function body.

func initData():
	var scene1 = {}
	scene1.name ="工厂"
	scene1.desc = "工厂的描述"
	scene1.create_time = "2023-07-10"
	scene1.create_person = "wzj"
	scene1.modify_time = "2023-07-10"
	scene1.modify_person = "wzj"
	scene1.id = 1
	scene1.url = "res://Model/AssemblyScenes/hangar/hangar.tscn"
	assembly_scenes.push_back(scene1)
	
	current_scene = assembly_scenes[0]
	pass

func update_scene_ui():
	var container = $ScrollContainer/HFlowContainer
	for n in container.get_children():
		container.remove_child(n)
		n.queue_free()
	for scene in assembly_scenes:
		var uiItem = scene_item_ui.instantiate()
		uiItem.update_ui(scene)
		uiItem.connect("select_item",select_item)
		uiItem.connect("select_item_right",select_item_right)
		container.add_child(uiItem)
		uiItem.set_owner(container)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if $AssScenePop.get_rect().has_point(event.position):
				return
			else:
				close_PopWin()
				
func select_item(position,item):
	current_scene = item
	update_current_scene()

func close_PopWin():
	$AssScenePop.visible = false
	$AssScenePop.set_global_position(Vector2(-300, 0))
	
func update_current_scene():
	var scene_instance = $"../../../HSplitContainer/VBoxContainer/TabContainer/动素显示/SubViewport/tbScene"

	scene_instance.change_scene(current_scene)
	pass
	
func select_item_right(position,item):
	$AssScenePop.visible = true
	$AssScenePop.position = position 
	var window = DisplayServer. window_get_size()
	if $AssScenePop.position.y > window.y-$AssScenePop.get_rect().size.y:
		$AssScenePop.position.y = window.y-$AssScenePop.get_rect().size.y

	
